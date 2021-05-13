
docker run -it --rm --user=$(id -u):$(id -g) -v /home/jgi/droxulconf:/config -v /a/src/x__ast__watch__210512/dropbox:/workdir  guillaumeai/server:droxul bash

docker build -t guillaumeai/server:droxul .


#docker run -i --rm --user=$(id -u):$(id -g) -v /home/jgi:/config -v /a/src/x__ast__watch__210512/dropbox:/workdir  guillaumeai/server:droxul bash

