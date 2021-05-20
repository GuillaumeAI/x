

docker build -t guillaumeai/server:gal-jgi .
echo "Pushing in bg....";docker push docker.io/guillaumeai/server:gal-jgi &> /dev/null &

