FROM debian:jessie
MAINTAINER Philipp Holler <philipp.holler93@googlemail.com>

ENV BACKUP_CONFDIR="/etc/backup-volumes"

RUN apt-get update \
 && apt-get install -y btrfs-tools sshfs rsync \
 && rm -r /var/lib/apt/lists/*

ADD /backup-volumes_entrypoint.sh /
RUN chmod +x /backup-volumes_entrypoint.sh
ENTRYPOINT ["/backup-volumes_entrypoint.sh"]

VOLUME ${BACKUP_CONFDIR}