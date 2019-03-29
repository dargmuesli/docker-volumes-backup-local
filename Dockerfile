FROM debian:jessie

ENV BACKUP_CONFDIR="/etc/backup-volumes"

RUN apt-get update \
 && apt-get install -y openssh-client rsync \
 && rm -r /var/lib/apt/lists/*

ADD /volumes-backup_entrypoint.sh /
RUN chmod +x /volumes-backup_entrypoint.sh
ENTRYPOINT ["/volumes-backup_entrypoint.sh"]

VOLUME ${BACKUP_CONFDIR}
