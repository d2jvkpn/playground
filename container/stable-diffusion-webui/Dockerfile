FROM ubuntu:22.04

ARG SD_Version=${SD_Version:-1.8.0}
ENV SD_Version=$SD_Version

RUN mkdir -p /app/bin
COPY bin /app/bin
RUN chmod a+x /app/bin/*.sh

RUN bash /app/bin/install.sh $SD_Version /app/sd-webui
WORKDIR /app/sd-webui

EXPOSE 7860
CMD ["/app/bin/entrypoint.sh", "--xformers", "--listen", "--api", "--port=7860"]
