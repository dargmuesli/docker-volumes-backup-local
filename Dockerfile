FROM debian:jessie

ENV BACKUP_CONFDIR="/etc/backup-volumes"

RUN apt-get update \
 && apt-get install -y openssh-client rsync \
 && rm -r /var/lib/apt/lists/*

ADD /backup-volumes_entrypoint.sh /
RUN chmod +x /backup-volumes_entrypoint.sh
ENTRYPOINT ["/backup-volumes_entrypoint.sh"]

VOLUME ${BACKUP_CONFDIR}
