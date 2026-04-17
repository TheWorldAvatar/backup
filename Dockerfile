ARG KOPIA_VERSION="$KOPIA_VERSION"
FROM kopia/kopia:$KOPIA_VERSION

RUN mkdir -p ~/.ssh

RUN apt-get update && apt-get install -y cron keychain && rm -rf /var/lib/apt/lists/*

RUN touch /usr/local/bin/kopia-backup.sh \
    && chmod +x /usr/local/bin/kopia-backup.sh

RUN echo "0 0 * * * /usr/local/bin/kopia-backup.sh >> /var/log/cron.log 2>&1" | crontab -

RUN touch /var/log/cron.log
# Override the entrypoint from the base image, "-f" keeps cron in the foreground
ENTRYPOINT ["cron", "-f"]

