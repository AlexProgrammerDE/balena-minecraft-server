FROM debian:trixie-slim AS build

ARG MCRCON_VERSION=0.7.2

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl gcc libc6-dev make \
    && curl -fsSL "https://github.com/Tiiffi/mcrcon/archive/refs/tags/v${MCRCON_VERSION}.tar.gz" | tar -xz -C /usr/src \
    && make -C "/usr/src/mcrcon-${MCRCON_VERSION}" \
    && cp "/usr/src/mcrcon-${MCRCON_VERSION}/mcrcon" /mcrcon

FROM debian:trixie-slim

COPY --from=build /mcrcon /usr/local/bin/mcrcon
COPY .bashrc /root/.bashrc

# Idle; open a terminal on this service in the dashboard to get the RCON console
CMD [ "sleep", "infinity" ]
