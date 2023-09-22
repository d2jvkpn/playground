FROM ubuntu:20.04

####
RUN apt update && apt -y upgrade
RUN apt -y install openjdk-11-jdk fontconfig fonts-dejavu fonts-noto-cjk-extra fonts-noto-cjk wget vim
RUN apt clean

####
# RUN wget https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-8.17.1-x64.bin
# RUN wget https://product-downloads.atlassian.com/software/confluence/downloads/atlassian-confluence-7.13.1-x64.bin
# RUN wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.27.tar.gz

COPY wk_apps/atlassian-jira-software-8.17.1-x64.bin /
COPY wk_apps/atlassian-confluence-7.13.1-x64.bin    /
COPY wk_apps/mysql-connector-java-8.0.27.tar.gz     /
RUN tar -xf mysql-connector-java-8.0.27.tar.gz

RUN chmod a+x atlassian-jira-software-8.17.1-x64.bin atlassian-confluence-7.13.1-x64.bin
