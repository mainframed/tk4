#!/bin/bash

# Download tk4-, source and cbt zip files
# extract wherever, copy all files in <zipfile>/dasd/* to a folder
# copy this script to that folder
# run this script
# requires https://github.com/SDL-Hercules-390/hyperion (git clone then ./configure and make)
# will make the folder ../extract to store dataset contents


IFS=$'\n'

for i in *; do
	echo "## Downloading VB 255 PDS contents with FTP"
	for FTP in `../hyperion/dasdls -caldt -expdt -hdr $i 2>/dev/null|grep "PO  VB      255"|awk '{print $1}'`; do
		#grep "PO  VB      255"|awk '{print $1}'`
		echo "$i :: $FTP"
		for DS in `curl ftp://localhost:21021/$FTP/ --user herc01:cul8tr 2>/dev/null|grep user|awk '{print $9}'`; do
			echo "# $i :: Downloading $FTP($DS)"
			 mkdir -p ../extract/$i/$FTP/
			 curl --use-ascii ftp://localhost:21021/$FTP/$DS --user herc01:cul8tr -o ../extract/$i/$FTP/$DS
		 done
	done
       for SEQ in `../hyperion/dasdls -caldt -expdt -hdr $i|grep " PS  FB       80"`; do
	       mkdir -p ../extract/$i
               DS=`echo $SEQ|awk '{print $1}'`	       
	       echo "# $i ::: Unloading Flat file $DS"
	       ../hyperion/dasdseq $i $DS
	       mv $DS ../extract/$i/$DS
	       ../hyperion/dasdseq $i $DS -ascii|grep 'HHC02691I ascii'|cut -d ' ' -f 3- > ../extract/$i/$DS.asc
       done
       for PDS in `../hyperion/dasdls -caldt -expdt -hdr $i|grep " PO  FB       80"`; do
               DS=`echo $PDS|awk '{print $1}'`
	       echo "# $i ::: Unloading Directory $DS"
	       mkdir -p ../extract/$i/$DS/
	       ../hyperion/dasdpdsu $i $DS ASCII ../extract/$i/$DS
	done
	for BIN in `../hyperion/dasdls -caldt -expdt -hdr $i|grep " PS  VB "`; do
	      DS=`echo $BIN|awk '{print $1}'`
	      echo "# $i ::: Downloading File $DS"
	      wget -P ../extract/$i/ ftp://herc01:cul8tr@localhost:21021/$DS
      done
done
