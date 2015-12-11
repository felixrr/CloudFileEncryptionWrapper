# CloudFileEncryptionWrapper
A bash script that handles gpg and tar and puts the output in the right place for syncing to a cloud provider whilst maintaining annonymous filenames.  This script does not do any syncing, just prepares them so that it doesn't matter so much whether you trust the cloud provider.

## Instructions:

Clone the code
    git clone https://github.com/felixrr/CloudFileEncryptionWrapper.git
Configure it
    nano backup.sh
Add it to your crontab
    crontab -e

Suggested cron is:
    */15 * * * * ~/CloudFileEncryptionWrapper/backup.sh > /dev/null 2>&1

Variables that can be configured are:
    systembase - set as the directory where you clone the code to
    syncbase - set as the directory that syncs with your cloud provider
    keyID - set as key you want to encrypt the files for, almost always going to be your own key ID
    filenamehashsalt - set as a random string, I suggest just a few characters, more than this is probably not worth it

Dependencies:
    gnupg
    tar
    Dropbox or other cloud sync service
