FROM jgwill/node
RUN apt update && apt upgrade -y
RUN apt install curl bash -y
RUN npm i npm --g
RUN npm i droxul --g
#FROM alpine:3.5
#MAINTAINER peez@stiffi.de

#RUN apk add --no-cache bash curl
COPY / /opt/dropbox_uploader
RUN mkdir -p /config && mkdir -p /workdir

VOLUME /config /workdir

WORKDIR /workdir

#ENTRYPOINT []
ENTRYPOINT ["/usr/bin/droxul", "-f", "/config/dropbox_uploader.conf"]

#ENTRYPOINT ["/opt/dropbox_uploader/dropbox_uploader.sh", "-f", "/config/dropbox_uploader.conf"]
