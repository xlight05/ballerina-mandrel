FROM alpine:3.14.3
LABEL maintainer="dev@ballerina.io"

# Ballerina runtime distribution filename.
ARG BALLERINA_DIST

# Add Ballerina runtime.
COPY ${BALLERINA_DIST} /root/

# Create folders, unzip distribution, create users, & set permissions.
RUN mkdir -p /ballerina/files \
    && addgroup troupe \
    && adduser -S -s /bin/bash -g 'ballerina' -G troupe -D ballerina \
    && apk add --upgrade apk-tools \
    && apk upgrade \
    && apk add --update --no-cache bash openjdk11-jre=11.0.14_p9-r0 docker-cli libc6-compat \
    && unzip /root/${BALLERINA_DIST} -d /ballerina/ > /dev/null 2>&1 \
    && mv /ballerina/ballerina* /ballerina/runtime \
    && mkdir -p /ballerina/runtime/logs \
    && chown -R ballerina:troupe /ballerina \
    && rm -rf /root/${BALLERINA_DIST} > /dev/null 2>&1 \
    && rm -rf /var/cache/apk/*

ENV BALLERINA_HOME /ballerina/runtime
ENV PATH $BALLERINA_HOME/bin:$PATH
ENV JAVA_HOME=/usr/lib/jvm/default-jvm

WORKDIR /home/ballerina
VOLUME /home/ballerina

USER ballerina
