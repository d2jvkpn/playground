FROM centos:7

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
RUN yum -y update                              && \
    yum -y install tree pigz zip dos2unix nano && \
    yum -y install vim jq wget curl git uuid   && \
    yum -y install python3 python3-pip

# pip3 config set global.index-url "https://pypi.douban.com/simple/"
# pip3 config set install.trusted-host "pypi.douban/simple"
# pip3 config get install.trusted-host
# cat ~/.config/pip/pip.conf

#RUN yum -y install nodejs npm &&                               \
#    npm config set registry https://registry.npm.taobao.org && \
#    npm install -g nodemon
# npm config list

RUN yum clean all

RUN umask 022; pip3 install --no-cache --upgrade pip  && \
    pip3 install --no-cache -r /root/requirements.txt && \
    python3 -m bash_kernel.install
# jupyter kernelspec list
# jupyter kernelspec uninstall unwanted-kernel

WORKDIR /mnt/work

# EXPOSE 9000
CMD ["bash", "/root/entrypoint.sh"]
