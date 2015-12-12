# CloudFileEncryptionWrapper
A bash script that handles gpg and tar and puts the output in the right place for syncing to a cloud provider whilst maintaining annonymous filenames.  This script does not do any syncing, just prepares them so that it doesn't matter so much whether you trust the cloud provider.

## BIG WARNING

Backup your encryption key pair somewhere other than in the cloud - if you loose it, your stumped.

## Instructions:

Clone the code  
> git clone https://github.com/felixrr/CloudFileEncryptionWrapper.git  

Configure it  
> nano backup.sh  

Add it to your crontab  
> crontab -e  

Suggested cron is:  
> */15 * * * * ~/CloudFileEncryptionWrapper/backup.sh > /dev/null 2>&1  

Variables that can be configured are:  
> systembase - set as the directory where you clone the code to  
> syncbase - set as the directory that syncs with your cloud provider  
> keyID - set as key you want to encrypt the files for, almost always going to be your own key ID  
> filenamehashsalt - set as a random string, I suggest just a few characters, more than this is probably not worth it  

Dependencies:  
> gnupg  
> tar  
> Dropbox or other cloud sync service
> crontab

## Considerations

Didn't want to re-encrypt everything following every check.  If no other reason - it is a waste of bandwidth.  But also, it could in theory be used in a differential style cryptanalysis attack which I probably don't understand well enough to explain here.

Didn't want filenames to be exposed.  This makes it difficult to handle, but having salted filename hashes and an encrypted filename hash seems to work well enough.

Wanted bandwidth efficiency where possible - hence the compression/tar.

Wanted cloud provider independence.  This system just needs to know where the cloud provider will sync file from.
