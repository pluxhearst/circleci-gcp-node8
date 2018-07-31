FROM debian:stretch-slim

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
#RUN groupadd -r mysql && useradd -r -g mysql mysql

MAINTAINER pierolucianihearst <piero.luciani.hearst@gmail.com>

##USER root

RUN apt-get update && apt-get install -y


ENV CLOUD_SDK_VERSION 178.0.0

RUN curl
RUN gcc
RUN python-dev
RUN python-setuptools
RUN apt-transport-https

RUN lsb-release
RUN openssh-client
RUN git
RUN easy_install -U pip
RUN pip install -U crcmod

RUN apt-get update && apt-get install -y

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
RUN echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -