FROM jgwill/node:v14.15.4
#FROM docker.io/jgwill/node
#FROM guillaumeai/server:ast-210502-compo-three-v2-dev
#FROM guillaumeai/server:httpd

RUN apt update 
#&&  apt upgrade -y
#RUN npm i node-gyp --g
#RUN npm i gyp --g
ARG DEBIAN_FRONTEND=noninteractive 
RUN apt install graphicsmagick -y
RUN npm i npm --g
RUN npm i yarn --g
RUN apt install exiftool -y #now in parent container
# RUN yarn --version && sleep 4
RUN yarn global add better-sqlite3@7.4.0
#RUN yarn global add thumbsup 
RUN npm install thumbsup --g

RUN yarn global add gia-ast-util
RUN yarn global add gia-ast

WORKDIR /root
COPY build/home/ .
#WORKDIR /a/bin
#COPY build/bin/ .

WORKDIR /tools
COPY build/home/ .

WORKDIR /work

# ARG UNAME=jgi
# ARG UID=1000
# ARG GID=1000
# RUN groupadd -g $GID -o $UNAME
# RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME
# USER $UNAME
# USER ubuntu
#ENTRYPOINT ["/usr/local/bin/thumbsup",]
