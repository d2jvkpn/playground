FROM ubuntu:22.04

ARG SD_Version=${SD_Version:-1.6.0}
ENV SD_Version=$SD_Version
ENV DEBIAN_FRONTEND=nointeractive

RUN mkdir -p /app/bin
COPY bin /app/bin
RUN chmod a+x /app/bin/*.sh

WORKDIR /app
RUN bash /app/bin/install.sh $SD_Version
WORKDIR /app/sd-webui

EXPOSE 7860
CMD ["/app/bin/entrypoint.sh", "--xformers", "--listen", "--api", "--port=7860"]
