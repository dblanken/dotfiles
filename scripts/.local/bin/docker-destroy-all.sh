#!/bin/bash

# This removes all containers, images, network, and caches
# Be careful!

echo 'Stopping Containers'
# Stop all containers
containers=`docker ps -a -q`
if [ -n "$containers" ] ; then
        docker stop $containers
fi

echo 'Deleting Containers'
# Delete all containers
containers=`docker ps -a -q`
if [ -n "$containers" ]; then
        docker rm -f -v $containers
fi

echo 'Deleting Images'
# Delete all images
images=`docker images -q -a`
if [ -n "$images" ]; then
        docker rmi -f $images
fi

echo 'Pruning Network'
docker network prune -f

echo 'Purging Lando Cache'
rm -rf ~/.lando/cache
