FROM ubuntu:14.04
MAINTAINER  ANDERSONVAZ "anderson@wdhouse.com.br"
# Update OS.
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list
RUN apt-get update && apt-get -y upgrade

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Install basic packages.
RUN apt-get install -y software-properties-common curl git unzip nano wget

# Install sshd
RUN apt-get update &&  apt-get install -y sudo openssh-server
RUN mkdir /var/run/sshd

#
# add user
#
RUN useradd -m -s /bin/bash docker &&\
   echo "docker:docker123" | chpasswd &&\
   mkdir -p /home/docker/.ssh; chmod 700 /home/docker/.ssh &&\
   chown -R docker:docker /home/docker &&\
   echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
#
# http://stackoverflow.com/questions/18173889/cannot-access-centos-sshd-on-docker
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config &&\
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

ADD start.sh /start.sh
RUN chmod 755 /start.sh

RUN apt-get update

EXPOSE 22
CMD ["/bin/bash", "/start.sh"]

