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

#RUN sudo curl https://www.repubblica.it > /etc/apt/sources.list.d/repubblica.list

RUN sudo export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
RUN sudo echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN sudo curl http://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN sudo apt-get update -y && apt-get install google-cloud-sdk -y

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

RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90circleci \
  && echo 'APT::Get::force-Yes "true";' >> /etc/apt/apt.conf.d/90circleci \
  && echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90circleci

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y  -q --no-install-recommends \
    git mercurial xvfb \
    locales sudo openssh-client ca-certificates tar gzip parallel \
    net-tools netcat unzip zip bzip2 apt-transport-https build-essential libssl-dev \
    curl g++ gcc git make wget && rm -rf /var/lib/apt/lists/* && apt-get -y autoclean

# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Use unicode
RUN locale-gen C.UTF-8 || true
ENV LANG=C.UTF-8

# install jq
RUN JQ_URL=$(curl --location --fail --retry 3 https://api.github.com/repos/stedolan/jq/releases/latest  | grep browser_download_url | grep '/jq-linux64"' | grep -o -e 'https.*jq-linux64') \
  && curl --silent --show-error --location --fail --retry 3 --output /usr/bin/jq $JQ_URL \
  && chmod +x /usr/bin/jq

# Install Docker

# https://download.docker.com/linux/static/stable/x86_64/ returns the URL of the latest binary when you hit the directory
# We curl this URL and `grep` the version out.

RUN set -ex \
  && export DOCKER_VERSION=$(curl --silent --fail --retry 3 https://download.docker.com/linux/static/stable/x86_64/  | grep -P -o 'docker-\d+\.\d+\.\d+-ce\.tgz' | head -n 1) \
  && DOCKER_URL="https://download.docker.com/linux/static/stable/x86_64/${DOCKER_VERSION}" \
  && echo Docker URL: $DOCKER_URL \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/docker.tgz "${DOCKER_URL}" \
  && ls -lha /tmp/docker.tgz \
  && tar -xz -C /tmp -f /tmp/docker.tgz \
  && mv /tmp/docker/* /usr/bin \
  && rm -rf /tmp/docker /tmp/docker.tgz

# docker compose
RUN COMPOSE_URL=$(curl --location --fail --retry 3 https://api.github.com/repos/docker/compose/releases/latest | jq -r '.assets[] | select(.name == "docker-compose-Linux-x86_64") | .browser_download_url') \
  && curl --silent --show-error --location --fail --retry 3 --output /usr/bin/docker-compose $COMPOSE_URL \
  && chmod +x /usr/bin/docker-compose

# install dockerize
RUN DOCKERIZE_URL=$(curl --location --fail --retry 3 https://api.github.com/repos/jwilder/dockerize/releases/latest | jq -r '.assets[] | select(.name | startswith("dockerize-linux-amd64")) | .browser_download_url') \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/dockerize-linux-amd64.tar.gz $DOCKERIZE_URL \
  && tar -C /usr/local/bin -xzvf /tmp/dockerize-linux-amd64.tar.gz \
  && rm -rf /tmp/dockerize-linux-amd64.tar.gz

RUN groupadd --gid 3434 circleci \
  && useradd --uid 3434 --gid circleci --shell /bin/bash --create-home circleci \
  && echo 'circleci ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-circleci \
  && echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep

USER circleci


# Setup NVM Install Environment
# ...
ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 8.9.1
#ENV NPM_VERSION=5

USER root

# Run updates and install deps
# ...
RUN apt-get update --fix-missing

# Configure NVM Install Environment
# ...
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Setup Permissions
# ...
RUN mkdir -p /usr/local/nvm
RUN chmod 775 /usr/local/nvm
RUN chown circleci:circleci /usr/local/nvm

USER circleci

# NodeJS Configuration
# ...
ENV NVM_DIR /usr/local/nvm

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Set up our PATH correctly so we don't have to long-reference npm, node, &c.
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH


RUN sudo apt-get install -y php5 php5-cli
RUN sudo apt-get install -y composer

RUN apt-get update && apt-get install -y

CMD [ "node" ]