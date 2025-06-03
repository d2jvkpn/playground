FROM python:3.10

ENV TZ="Asia/Shanghai"

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bk && \
  sed -i 's#http://\(deb\|security\).debian.org#https://mirrors.aliyun.com#g' \
  /etc/apt/sources.list

RUN apt -y update && \
  apt -y upgrade && \
  apt clean && \
  apt autoclean && \
  apt remove && \
  apt autoremove

# ubuntu
RUN useradd -m -u 1000 -s /bin/bash hello
# alpine
# RUN adduser -D -u 1000 hello
USER hello
ENV PATH="/home/hello/.local/bin:$PATH"
WORKDIR /home/hello/

ADD ./requirements.txt  ./

RUN pip3 config set global.index-url 'https://pypi.douban.com/simple/' && \
  pip3 config set install.trusted-host 'pypi.douban/simple'

RUN pip3 install --no-cache -r requirements.txt
