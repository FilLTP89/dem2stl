# construction:
# docker buildx build . -t dem2stl -f Dockerfile
FROM debian:stable-slim as build

COPY dist/*.whl /
RUN apt-get update && \
    apt-get install -y g++ python3-venv python3-dev python3-numpy gdal-bin libgdal-dev && apt-get clean && \
    python3 -m venv /dem2stl && . /dem2stl/bin/activate && \
    pip install gdal==`gdalinfo --version | awk  '{ print $2 }' | sed '$ s/.$//'` && \ 
    pip install --find-links=. dem2stl && rm *.whl

# example on how to test it:

    # start a container in background
    # docker run -d -i -t dem2stl --name docker_dem2stl bash

    # copy the file(s) you want to convert
    # docker cp example docker_dem2stl:/test
    
    # process the conversion to stl in a "test.stl"
    # docker exec -d dem2stl /dem2stl/bin/dem2stl --raster /test/GeogToWGS84GeoKey5.tif --stl test.stl

    # copy the result to your directory (outside of the docker)
    # docker cp docker_dem2stl:test.stl .