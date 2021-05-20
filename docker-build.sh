rm -rf build
#mkdir -p build/bin
mkdir -p build/home
#cp -r $binroot/ build/bin
cp /home/jgi/.bash* build/home
#cp /home/jgi/.bash* build/home

docker build -t guillaumeai/server:gal .
echo "Pushing in bg....";docker push docker.io/guillaumeai/server:gal &> /dev/null &

