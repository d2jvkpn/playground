FROM alpine:3

ARG REGION=${REGION}
ARG SCALA_Version=${SCALA_Version:-2.13}
ARG KAFKA_Version=${KAFKA_Version:-3.5.0}

COPY scripts /opt/scripts
RUN chmod a+x /opt/scripts/entrypoint.sh

RUN script=/opt/scripts/${REGION}.alpine.sh; \
  if [ -f $script ]; then sh $script; fi

RUN tag=${SCALA_Version}-${KAFKA_Version} && \
  apk --no-cache update && apk --no-cache upgrade && \
  apk --no-cache add tzdata bash openjdk17 wget && \
  wget https://downloads.apache.org/kafka/${KAFKA_Version}/kafka_${tag}.tgz && \
  tar -xf kafka_${tag}.tgz && mv kafka_${tag} /opt/kafka && rm kafka_${tag}.tgz && \
  apk del wget

# mkdir -p /opt/kafka && tar -xf kafka_${tag}.tgz --strip-components=1 -C /opt/kafka
# kafka_2.13-3.5.0.tgz

RUN adduser -D -u 1000 d2jvkpn

# RUN mkdir -p /home/d2jvkpn/kafka/configs /home/d2jvkpn/kafka/data && \
#   mkdir -p /opt/kafka/logs && \
#   chown -R d2jvkpn /home/d2jvkpn/kafka /opt/kafka/logs

RUN kafka_dir=/home/d2jvkpn/kafka; \
  mkdir -p $kafka_dir/configs $kafka_dir/data $kafka_dir/logs && \
  ln -s $kafka_dir/logs /opt/kafka/logs && \
  chown -R d2jvkpn $kafka_dir

ENV PATH=/opt/kafka/bin:$PATH
USER d2jvkpn
WORKDIR /home/d2jvkpn/kafka

EXPOSE 9092 9093
# ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
CMD ["/opt/scripts/entrypoint.sh"]
