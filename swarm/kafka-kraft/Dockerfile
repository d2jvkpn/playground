FROM alpine:3

ARG BUILD_Region=${BUILD_Region}
ARG SCALA_Version=${SCALA_Version}
ARG KAFKA_Version=${KAFKA_Version}
ARG KAFKA_Tag=${SCALA_Version}-${KAFKA_Version}

ENV KAFKA_Version=${KAFKA_Version}
ENV KAFKA_Tag=${KAFKA_Tag}

COPY bin /app/bin
RUN chmod a+x /app/bin/*.sh

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: $BUILD_Region"; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
  fi

RUN apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add tzdata bash openjdk17 wget

RUN link=https://downloads.apache.org/kafka/${KAFKA_Version}/kafka_${KAFKA_Tag}.tgz; \
  wget $link && \
  tar -xf kafka_${KAFKA_Tag}.tgz && \
  mv kafka_${KAFKA_Tag} /opt/kafka && \
  rm kafka_${KAFKA_Tag}.tgz && \
  apk del wget

# mkdir -p /opt/kafka && tar -xf kafka_${tag}.tgz --strip-components=1 -C /opt/kafka

# RUN mkdir -p /home/d2jvkpn/kafka/configs /home/d2jvkpn/kafka/data && \
#   mkdir -p /opt/kafka/logs && \
#   chown -R d2jvkpn /home/d2jvkpn/kafka /opt/kafka/logs

RUN mkdir -p /app/configs /app/data /app/logs && \
  ln -s /app/logs /opt/kafka/logs

ENV PATH=/opt/kafka/bin:$PATH
WORKDIR /app

EXPOSE 9092 9093
# ENTRYPOINT ["/app/bin/entrypoint.sh"]
CMD ["/app/bin/entrypoint.sh"]
