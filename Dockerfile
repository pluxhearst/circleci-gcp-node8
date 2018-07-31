FROM debian:stretch-slim

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
#RUN groupadd -r mysql && useradd -r -g mysql mysql

MAINTAINER pierolucianihearst <piero.luciani.hearst@gmail.com>

##USER root

RUN apt-get update && apt-get install -y


ENV CLOUD_SDK_VERSION 178.0.0

RUN apt-get install -y curl
RUN apt-get install -y gcc
RUN apt-get install -y python-dev
RUN apt-get install -y python-setuptools
RUN apt-get install -y apt-transport-https

RUN apt-get install -y lsb-release
RUN apt-get install -y openssh-client
RUN apt-get install -y git

RUN easy_install -U pip
RUN pip install -U crcmod

##RUN apt-get install -y easy_install -U pip
##RUN pip install -U crcmod

RUN apt-get update

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
RUN echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

RUN sudo apt-get install -y google-cloud-sdk
RUN sudo apt-get install -y google-cloud-sdk-app-engine-python
RUN sudo apt-get install -y google-cloud-sdk-app-engine-python-extras
RUN sudo apt-get install -y google-cloud-sdk-app-engine-java
RUN sudo apt-get install -y google-cloud-sdk-app-engine-go
RUN sudo apt-get install -y google-cloud-sdk-datalab
RUN sudo apt-get install -y google-cloud-sdk-datastore-emulator
RUN sudo apt-get install -y google-cloud-sdk-pubsub-emulator
RUN sudo apt-get install -y google-cloud-sdk-cbt
RUN sudo apt-get install -y google-cloud-sdk-cloud-build-local
RUN sudo apt-get install -y google-cloud-sdk-bigtable-emulator
RUN sudo apt-get install -y kubectl

RUN gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image

#RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90circleci \
#  && echo 'APT::Get::force-Yes "true";' >> /etc/apt/apt.conf.d/90circleci \
#  && echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90circleci

#ENV DEBIAN_FRONTEND=noninteractive

# RUN sudo apt-get install php5 php5-cli
# RUN sudo apt-get install -y composer