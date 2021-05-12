FROM jgwill/node
#FROM guillaumeai/server:ast-210502-compo-three-v2-dev
#FROM guillaumeai/server:httpd

RUN apt update && apt upgrade -y
RUN npm i npm --g
RUN npm i yarn --g
RUN npm i gia-ast --g
ARG DEBIAN_FRONTEND=noninteractive 
RUN apt install graphicsmagick -y
RUN npm i thumbsup --g
RUN apt install exiftool -y
