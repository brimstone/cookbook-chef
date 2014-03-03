FROM brimstone/ubuntu:12.04

RUN apt-get update; apt-get upgrade

ADD . /tmp/chef/

RUN /sbin/upstart '/tmp/chef/docker/build'; /tmp/chef/docker/install

EXPOSE 443

VOLUME ["/var/backups"]
