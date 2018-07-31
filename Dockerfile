FROM debian:stretch-slim

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
#RUN groupadd -r mysql && useradd -r -g mysql mysql

MAINTAINER pierolucianihearst <piero.luciani.hearst@gmail.com>

##USER root

RUN apt-get update && apt-get install -y


ENV CLOUD_SDK_VERSION 178.0.0

RUN apt-get -qqy update && apt-get -qqy upgrade && apt-get install -qqy \
        curl \
        gcc \
        python-dev \
        python-setuptools \
        apt-transport-https \
        lsb-release \
        openssh-client \
        git \
    && easy_install -U pip && \
    pip install -U crcmod   && \
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y google-cloud-sdk=${CLOUD_SDK_VERSION}-0 \
        google-cloud-sdk-app-engine-python \
        google-cloud-sdk-app-engine-java \
        google-cloud-sdk-app-engine-go \
        google-cloud-sdk-datalab \
        google-cloud-sdk-datastore-emulator \
        google-cloud-sdk-pubsub-emulator \
        google-cloud-sdk-bigtable-emulator \
        google-cloud-sdk-cbt \
        kubectl && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image