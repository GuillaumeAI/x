rm -rf build
mkdir -p build/bin
mkdir -p build/home
cp $binroot/*sh build/bin
cp /home/jgi/.bash* build/home
#cp /home/jgi/.bash* build/home

docker build -t guillaumeai/server:gal .
docker push docker.io/guillaumeai/server:gal &> /dev/null &

