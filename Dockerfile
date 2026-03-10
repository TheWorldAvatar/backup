FROM kopia/kopia:20260224.0.42919

RUN mkdir -p ~/.ssh

RUN apt-get update && apt-get install -y cron keychain && rm -rf /var/lib/apt/lists/*

RUN touch /usr/local/bin/kopia-backup.sh \
    && chmod +x /usr/local/bin/kopia-backup.sh

RUN echo "0 0 * * * root /usr/local/bin/kopia-backup.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/backup-cron

RUN chmod 0644 /etc/cron.d/backup-cron \
    && crontab /etc/cron.d/backup-cron

RUN touch /var/log/cron.log

# Reset the entrypoint from the base image
ENTRYPOINT []

CMD ["cron", "-f"]