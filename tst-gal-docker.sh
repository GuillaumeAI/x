
#Generates a gallery using Docker
docker run -it --rm -v $(pwd):/work guillaumeai/server:gal /a/bin/gallery_html_maker2.sh /work/samples /works/tests/docker-gal-2105132003
