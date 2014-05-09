# Home backup tools #

My set of scripts for backing up my Ubuntu laptop and my wife's macbook air 
to a book-sized Linux that acts as my backup server.  

## Goal ##

Silently and automatically back-up my and my wife's home directories to a
backup server at home and also to the cloud.  These are backups to disk.

Ignore snapshots or other synchronization because the goal here is to back-up
unstructured files and data.

Ignore system files because it is pretty easy to re-install Ubuntu or MacOS X.

## Constraints ##

* Don't run untrusted software as root.
* Keep more than one backup over time.

## Concept of Operation ##

* Script on client (running non-root) wakes up and checks:
   - whether a back-up is in progress, and 
   - whether it has been long enough that a back-up is needed
* Script lists a directory that is an autofs mount from the server
* If laptop is at home, the mount and therefore the listing works
* Otherwise the script exits.
* Assuming the script is still running, it locks a file and runs the backup
* Backup uses rsync with --link-dest argument to do hard-links for files
  that have not changed.
* Script on server (running non-root) wakes up periodically and checks whether
  any new data must be backed up to the Cloud, and then does it.

## Backup Server Setup ##

* Create a "backup" user on the backup server to host the backup share
* Create a user on the backup server for each user home directory to back-up
* In the home directory of the backup user, create a sub-directory for each
  user to be backed up, owned by that user.
* Configure Samba to allow mounts of the backup server
* Setup a cloud backup of backup users home directory on the backup server
* This cloud backup should not run as root

__NOTE__: One option for security is to mount the backup user's home
 directory with encfs, so that the underlying files on disk are encrypted.  I've chosen to simply trust that SpiderOak is as private as is claimed.

## Client Setup ##

* Install autofs and cifs-utils
* Create a file `/etc/auto.smb.creds` with permissions 0600 with user/password for share.
* Create a file `/etc/auto.smb`.   Mine looks like this:
* Edit `/etc/auto.master` to refer to it.  Here's the line that does it:
* Create directory where the mount will occur and adjust permissions
* Restart autofs and test
* Use `make install` to install this stuff in `/usr/local/bin` 
* Use cron to run `auto_backup` periodically.  My crontab looks like this:

## License ##

MIT License

## Related Stuff ##

Using `rsync` this way is nothing new:

* [http://www.mikerubel.org/computers/rsync_snapshots/](http://www.mikerubel.org/computers/rsync_snapshots/)
* [http://www.math.ualberta.ca/imaging/rlbackup/](http://www.math.ualberta.ca/imaging/rlbackup/)

