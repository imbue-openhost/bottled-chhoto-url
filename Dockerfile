FROM ghcr.io/sintan1729/chhoto-url:7.2.4-alpine

COPY entrypoint.sh /entrypoint.sh

ENV CHHOTO_SQLITE_USE_WAL_MODE=True
ENV CHHOTO_LISTEN_PORT=4567

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/chhoto-url"]
