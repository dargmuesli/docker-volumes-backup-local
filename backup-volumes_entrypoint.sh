#!/bin/bash
set -e

if [ -z "$SSHFS_CONNECTION" ]; then
  echo "SSHFS_CONNECTION not set."
  exit 1
fi

: ${BACKUP_SOURCEDIR=/docker-volumes}
: ${BACKUP_TARGETDIR=/mnt}
: ${SSHFS_IDENTITYFILE=rhswiwi5.nas.key}

chmod 600 $BACKUP_CONFDIR/$SSHFS_IDENTITYFILE
sshfs -o StrictHostKeyChecking=no -o IdentityFile=$BACKUP_CONFDIR/$SSHFS_IDENTITYFILE $SSHFS_CONNECTION $BACKUP_TARGETDIR

# For each directory in the volume folder do:
for directory_name in $(find $BACKUP_SOURCEDIR/* -maxdepth 0 -type d -printf "%f\n"); do
	# If the directory is a named volume, i.e. no hexadecimal, 64 characters long folder name
	if [ -z $(echo $directory_name | grep -E '[0-9a-f]{64}') ]; then
		# rsync it to the target directory
		rsync -avz $BACKUP_SOURCEDIR/$directory_name $BACKUP_TARGETDIR/$directory_name
	fi
done