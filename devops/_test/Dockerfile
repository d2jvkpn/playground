FROM debian:trixie

LABEL name=local/test

RUN groupadd -g 1000 appuser && \
    useradd -s /bin/bash -m -u 100 -g 1000 appuser

USER appuser

WORKDIR /home/appuser

SHELL ["/bin/bash", "-lc"]

RUN source .bashrc && \
    echo 'export VAL=2048' >> .bashrc && \
    echo 'export NAME=Jane' >> .bash_aliases

RUN source .bashrc && \
    echo $SHELL, $VAL, $NAME > test.txt
