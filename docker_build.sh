#!/bin/bash
set -eux

image_name=kiyoad/twimg2rss
id=$(date '+%Y%m%d')

script -c "docker build --build-arg INSTALL_USER=${LOGNAME} --build-arg UID=$(id -u) -t ${image_name} ." "docker_build_${id}.log"
