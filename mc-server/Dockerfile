FROM eclipse-temurin:25-jre

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl jq \
    && rm -rf /var/lib/apt/lists/*

COPY serverfiles /serverfiles
COPY start.sh /usr/src/start.sh

CMD [ "bash", "/usr/src/start.sh" ]
