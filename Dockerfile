FROM alpine

# min hour day month weekday
ARG CRON_EXPRESSION="0 0 * * *"
ENV BACKUP_CONFDIR=/etc/backup-volumes/

VOLUME $BACKUP_CONFDIR
VOLUME /mnt/backup-target/

RUN apk --no-cache add rsync

COPY /volumes-backup_entrypoint /
RUN chmod +x /volumes-backup_entrypoint
RUN echo "$CRON_EXPRESSION /volumes-backup_entrypoint" > /etc/crontabs/root
CMD crond -l 2 -f
