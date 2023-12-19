FROM ubuntu:22.04

ARG TZ=${TZ:-Asia/Shanghai}
ARG BUILD_Region=${BUILD_Region}
ENV TZ=${TZ}

COPY bin /app/bin
RUN chmod a+x /app/bin/*.sh

WORKDIR /app

RUN BUILD_Region=$BUILD_Region bash /app/bin/install.sh

# EXPOSE 8080
# CMD ["/app/bin/entrypoint.sh"]
ENTRYPOINT ["/app/bin/entrypoint.sh"]
