FROM debian:stretch-slim

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
#RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get update && apt-get install -y