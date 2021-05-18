FROM guillaumeai/server:gal
RUN groupdel -f ubuntu
RUN userdel --remove  ubuntu

ARG UNAME=jgi
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME
USER $UNAME
