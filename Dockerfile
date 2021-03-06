FROM alpine:edge

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="try2codesecure" \
    com.microscaling.license="MIT" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="Tor network client" \
    org.label-schema.url="https://www.torproject.org" \
    org.label-schema.vcs-url="https://github.com/try2codesecure/docker_tord.git" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.docker.cmd="docker run -d -p 9001:9001 -p 9030:9030 --name tor try2codesecure/docker_tord" \
    org.label-schema.schema-version="1.0"

RUN apk add --no-cache tor && \
    sed "1s/^/SocksPort 0.0.0.0:9050\n/" /etc/tor/torrc.sample > /etc/tor/torrc

EXPOSE 9001 9030 9050

VOLUME ["/var/lib/tor"]

USER tor

CMD ["/usr/bin/tor"]