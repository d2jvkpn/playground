FROM alpine:3

ARG BUILD_Region=${BUILD_Region}
ARG KAFKA_Version=${KAFKA_Version}
ARG SCALA_Version=${SCALA_Version}

ENV KAFKA_Version=${KAFKA_Version}
ENV SCALA_Version=${SCALA_Version}

COPY bin /app/bin
RUN chmod a+x /app/bin/*.sh

RUN if [ "$BUILD_Region" = "cn" ]; then \
    echo "==> BUILD_Region: $BUILD_Region"; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories; \
  fi

RUN apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add tzdata bash openjdk21 wget

RUN tag=${SCALA_Version}-${KAFKA_Version}; \
  link=https://downloads.apache.org/kafka/${KAFKA_Version}/kafka_${tag}.tgz; \
  wget $link && \
  tar -xf kafka_${tag}.tgz && \
  mv kafka_${tag} /opt/kafka && \
  rm kafka_${tag}.tgz && \
  apk del wget

# mkdir -p /opt/kafka && tar -xf kafka_${tag}.tgz --strip-components=1 -C /opt/kafka

RUN mkdir -p /app/kafka/data /app/kafka/logs && \
  ln -s /app/kafka/logs /opt/kafka/logs

ENV PATH=/opt/kafka/bin:$PATH
WORKDIR /app

EXPOSE 9092 9093
# ENTRYPOINT ["/app/bin/entrypoint.sh"]
CMD ["/app/bin/entrypoint.sh"]
