FROM debian:trixie-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-server openssh-sftp-server \
    && rm -rf /var/lib/apt/lists/*

COPY start.sh /usr/src/start.sh

CMD [ "bash", "/usr/src/start.sh" ]
