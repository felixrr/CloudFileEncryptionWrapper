#!/bin/bash

# configuration

systembase="/home/[USERNAME]/CloudFileEncryptionWrapper/"
syncbase="/home/[USERNAME]/CloudFileEncryptionWrapper/Dropbox/"
keyID="0x[YOURKEYHERE]"
filenamehashsalt="[YOURRANDOMSTRINGHERE]"

# initialisation of global vars

IFS=$'\n'
changedetected=0
cd $systembase
touch Working/filelist.txt
touch Working/oldfilelist.txt
filelist=`find Files -not -name '\.*' -not -name '*~' -type f -name \* -print | sed "s/ /\ /g"`

# build file current list

mv Working/filelist.txt Working/oldfilelist.txt
for file in $filelist; do
   contenthash=`sha256sum $file | sed "s/  /:/g"`
   namehash=`echo $filenamehashsalt$file | sha256sum | awk {'print $1'}`
   echo $contenthash":"$namehash >> Working/filelist.txt
done

# do comparison of old vs new files

for line in $(cat Working/filelist.txt); do 
   name=`echo $line | awk -F ":" {'print $2'}`
   hashname=`echo $line | awk -F ":" {'print $3'}`
   comparison=`grep $line Working/oldfilelist.txt`
   if [ "$comparison" == "" ]; then
      echo "Change detected in $name (hashname $hashname)"
      changedetected=1
      echo "Removing old compressed and encrypted files"
      rm -f Working/$hashname.tar.gz
      rm -f Working/$hashname.tar.gz.asc
      echo "Creating new compressed file"
      tar -zcvf Working/$hashname.tar.gz $name
      echo "Creating new encrypted file"
      gpg -r $keyID -ae Working/$hashname.tar.gz
      echo "Copying encrypted file to Sync folder"
      cp Working/$hashname.tar.gz.asc $syncbase
   else
      file=`echo $line | awk -F ":" {'print $2'}`
      echo "No change in $file (hashname $hashname)"
   fi
done

if [ $changedetected == 1 ]; then
   echo "Removing old compressed and encrypted filelist"
   rm -f Working/filelist.tar.gz
   rm -f Working/filelist.tar.gz.asc
   echo "Creating new compressed filelist"
   tar -zcvf Working/filelist.tar.gz Working/filelist.txt
   echo "Creating new encrypted filelist"
   gpg -r $keyID -ae Working/filelist.tar.gz
   echo "Copying encrypted filelist to Sync folder"
   cp Working/filelist.tar.gz.asc $syncbase
fi
