#!/bin/sh

rm -rf artifacts
mkdir artifacts
docker build -t lunapnr .
docker run --name lunapnr -it lunapnr
docker cp lunapnr:/lunapnr.tgz ./artifacts/
docker system prune -f
