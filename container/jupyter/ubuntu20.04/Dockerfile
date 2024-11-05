FROM ubuntu:20.04

ENV TZ="Asia/Shanghai"

#### config
RUN mkdir -p /root/.config/pip/
COPY configs/pip.conf          /root/.config/pip/pip.conf
COPY configs/requirements.txt  /root/requirements.txt
COPY configs/jupyter.py        /root/jupyter.py
COPY configs/entrypoint.sh     /root/entrypoint.sh

COPY configs/bashrc /opt/bashrc
RUN echo "test -s /opt/bashrc && source /opt/bashrc" >> /etc/bashrc && \
    echo "test -s /opt/bashrc && source /opt/bashrc" >> /etc/profile

RUN ln -f -s /usr/share/zoneinfo/$TZ /etc/localtime

#### install programs
RUN apt -y update && apt -y upgrade            && \
    apt -y install tree pigz zip dos2unix nano && \
    apt -y install vim jq wget curl git uuid   && \
    apt -y install python3 python3-pip

RUN apt remove && apt autoremove
RUN apt clean && apt autoclean

RUN umask 022; pip3 install --no-cache --upgrade pip  && \
    pip3 install --no-cache -r /root/requirements.txt && \
    python3 -m bash_kernel.install

WORKDIR /mnt/work

# EXPOSE 9000
CMD ["bash", "/root/entrypoint.sh"]
