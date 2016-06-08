#!/bin/bash
set -e

if [ -z "$BACKUP_TARGETDIR" ]; then
  echo "SSHFS_CONNECTION not set."
  exit 1
fi

: ${BACKUP_SOURCEDIR=/docker-volumes}
: ${SSH_IDENTITYFILE=rhswiwi5.nas.key}

chmod 600 $BACKUP_CONFDIR/$SSHFS_IDENTITYFILE

# For each directory in the volume folder do:
for directory_name in $(find $BACKUP_SOURCEDIR/* -maxdepth 0 -type d -printf "%f\n"); do
	# If the directory is a named volume, i.e. no hexadecimal, 64 characters long folder name
	if [ -z $(echo $directory_name | grep -E '[0-9a-f]{64}') ]; then
		# rsync it to the target directory and save permissions to a file next to it
		rsync -avz --no-o --no-g -e "ssh -i $BACKUP_CONFDIR/$SSHFS_IDENTITYFILE -o StrictHostKeyChecking=no" $BACKUP_SOURCEDIR/$directory_name $BACKUP_TARGETDIR/
		getfacl -R $BACKUP_SOURCEDIR/$directory_name > $BACKUP_TARGETDIR/$directory_name.meta
	fi
done
