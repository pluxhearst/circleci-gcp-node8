FROM debian:scratch


MAINTAINER pierolucianihearst <piero.luciani.hearst@gmail.com>

USER root

RUN apt-get -qqy update
RUN apt-get -qqy upgrade


CMD ["bash"]