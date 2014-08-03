FROM ubuntu:14.04
MAINTAINER mooxavier <mooxavier [at] gmail . com>

ENV JIRA_VERSION 6.3
ENV DEBIAN_FRONTEND noninteractive
ENV CONTEXT_PATH ROOT

# Install packages for ubuntu 14.04 LTS
RUN apt-get update
RUN apt-get install -y git-core curl sudo xmlstarlet software-properties-common python-software-properties mysql-client
RUN apt-add-repository ppa:webupd8team/java -y
RUN apt-get update

# Install Java 7
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install oracle-java7-installer -y
RUN apt-get clean

# Setup volume handling
RUN /usr/sbin/groupadd atlassian
ADD own_volume.sh /usr/local/bin/own_volume
RUN echo "%atlassian ALL=NOPASSWD: /usr/local/bin/own_volume" >> /etc/sudoers
RUN mkdir -p /opt/atlassian-home

# Add common script functions
ADD common.sh /usr/local/share/atlassian/common.sh
RUN chgrp atlassian /usr/local/share/atlassian/common.sh
RUN chmod g+w /usr/local/share/atlassian/common.sh

# Install Jira
RUN curl -L http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-${JIRA_VERSION}.tar.gz -o /root/jira.tar.gz
RUN /usr/sbin/useradd --create-home --home-dir /opt/jira --groups atlassian --shell /bin/bash jira
RUN tar zxf /root/jira.tar.gz --strip=1 -C /opt/jira
RUN chown -R jira:jira /opt/atlassian-home
RUN echo "jira.home = /opt/atlassian-home" > /opt/jira/atlassian-jira/WEB-INF/classes/jira-application.properties
RUN chown -R jira:jira /opt/jira
RUN mv /opt/jira/conf/server.xml /opt/jira/conf/server-backup.xml

# Add common script functions
ADD launch_jira.sh /launch_jira

# Launching Jira
WORKDIR /opt/jira
VOLUME ["/opt/atlassian-home"]
EXPOSE 8080
USER jira
CMD ["/launch_jira"]
