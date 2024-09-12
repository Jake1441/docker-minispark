#!/bin/bash

set -e

TAG=3.3.1-java8

build() {
    NAME=$1
    IMAGE=desertroam/hadoop-$NAME:$TAG
    cd $([ -z "$2" ] && echo "./$NAME" || echo "$2")
    echo '--------------------------' building $IMAGE in $(pwd)
    docker build -t $IMAGE .
    cd -
}

if [ $# -eq 0 ]
  then
    build base
    build master
    build worker
    build historyserver
    build namenode
    build datanode
    build nodemanager
    build resourcemanager
    build pyspark-notebook
  else
    build $1 $2
fi
