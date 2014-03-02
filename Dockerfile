FROM brimstone/ubuntu:12.04

RUN apt-get update; apt-get upgrade

RUN apt-get install -y curl cron

RUN apt-get clean

RUN curl -L https://www.opscode.com/chef/install.sh | bash

RUN echo "kernel.shmmax = 268435456" >> /etc/sysctl.conf

ADD . /tmp/chef/

RUN /sbin/upstart '/tmp/chef/docker/build'; /tmp/chef/docker/install

EXPOSE 443

VOLUME ["/var/backups"]
