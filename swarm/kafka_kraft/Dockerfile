FROM alpine:3

ARG REGION=${REGION}
ARG SCALA_Version=${SCALA_Version}
ARG KAFKA_Version=${KAFKA_Version}
ARG KAFKA_Tag=${SCALA_Version}-${KAFKA_Version}

COPY bin /opt/bin
RUN chmod a+x /opt/bin/entrypoint.sh

RUN script=/opt/bin/${REGION}.alpine.sh; \
  if [ -f $script ]; then sh $script; fi

RUN link=https://downloads.apache.org/kafka/${KAFKA_Version}/kafka_${KAFKA_Tag}.tgz; \
  apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add tzdata bash openjdk17 wget && \
  wget $link && \
  apk del wget && \
  tar -xf kafka_${KAFKA_Tag}.tgz && \
  mv kafka_${KAFKA_Tag} /opt/kafka && \
  rm kafka_${KAFKA_Tag}.tgz && \
  echo $link > /opt/kafka.txt

# mkdir -p /opt/kafka && tar -xf kafka_${tag}.tgz --strip-components=1 -C /opt/kafka

# RUN mkdir -p /home/d2jvkpn/kafka/configs /home/d2jvkpn/kafka/data && \
#   mkdir -p /opt/kafka/logs && \
#   chown -R d2jvkpn /home/d2jvkpn/kafka /opt/kafka/logs

RUN kafka_dir=/home/d2jvkpn/kafka; \
  mkdir -p $kafka_dir/configs $kafka_dir/data $kafka_dir/logs && \
  ln -s $kafka_dir/logs /opt/kafka/logs

ENV PATH=/opt/kafka/bin:$PATH
WORKDIR /home/d2jvkpn/kafka

EXPOSE 9092 9093
# ENTRYPOINT ["/opt/bin/entrypoint.sh"]
CMD ["/opt/bin/entrypoint.sh"]
