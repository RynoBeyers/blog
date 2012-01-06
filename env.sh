#!/bin/bash

# set defaults
NODEJS_VER="0.6.6"
MONGODB_VER="2.0.1"

# import configurations
source conf.sh


CURRENT_DIR="$PWD"
ROOT_DIR="$( cd "$( dirname "$0" )" && pwd )"
ENV_DIR="$ROOT_DIR/env"
SRC_DIR="$ENV_DIR/src"
DOWNLOAD_DIR="$ENV_DIR/download"
NODEJS_DIR="$ENV_DIR/nodejs-$NODEJS_VER"
NODEJS_MODULES_DIR="$ROOT_DIR/node_modules"


mongodb_init () {
    # fetch and compile mongodb
    MONGODB_TAR="$DOWNLOAD_DIR/mongodb-src-r$MONGODB_VER.tar.gz"
    cd $DOWNLOAD_DIR

    # fetch mongodb source
    if [ ! -f "$MONGODB_TAR" ]; then
        wget -O "$MONGODB_TAR" "http://downloads.mongodb.org/src/mongodb-src-r$MONGODB_TAR.tar.gz"
    fi

    # ensure installation of prerequisites
    sudo apt-get install tcsh git-core scons g++
    sudo apt-get install libpcre++-dev libboost-dev libreadline-dev xulrunner-1.9.2-dev
    sudo apt-get install libboost-program-options-dev libboost-thread-dev libboost-filesystem-dev libboost-date-time-dev

    # compile mongodb
    if [ ! -f "$NODEJS_DIR/bin/node" ]; then
        NODEJS_SRC_DIR="$SRC_DIR/nodejs-$NODEJS_VER"
        cd "$SRC_DIR"
        mkdir "$NODEJS_SRC_DIR"
        tar xvf "$NODEJS_TAR" --strip 1 -C "$NODEJS_SRC_DIR"
        cd "$NODEJS_SRC_DIR"
        ./configure --prefix="$NODEJS_DIR"
        make
        make install
    fi

}


env() {

    case $1 in
    "init" )

        mkdir -p "$ENV_DIR"
        mkdir -p "$SRC_DIR"
        mkdir -p "$DOWNLOAD_DIR"

        # fetch, compile and install nodejs
        NODEJS_TAR="$DOWNLOAD_DIR/nodejs-$NODEJS_VER.tar.gz"
        cd "$DOWNLOAD_DIR"

        # fetch nodejs code archive
        if [ ! -f "$NODEJS_TAR" ]; then
            wget -O "$NODEJS_TAR" "https://github.com/joyent/node/tarball/v$NODEJS_VER"
        fi

        # compile and install nodejs
        if [ ! -f "$NODEJS_DIR/bin/node" ]; then
            NODEJS_SRC_DIR="$SRC_DIR/nodejs-$NODEJS_VER"
            cd "$SRC_DIR"
            mkdir "$NODEJS_SRC_DIR"
            tar xvf "$NODEJS_TAR" --strip 1 -C "$NODEJS_SRC_DIR"
            cd "$NODEJS_SRC_DIR"
            ./configure --prefix="$NODEJS_DIR"
            make
            make install
        fi

        # set node installed path
        export PATH="$NODEJS_DIR/bin:$PATH"
        export NODE_PATH="$NODEJS_DIR/lib"

        # install npm
        if [ ! -f "$NODEJS_DIR/bin/npm" ]; then
            curl http://npmjs.org/install.sh | clean=yes sh
        fi

        # return to the original directory
        cd "$CURRENT_DIR"

    ;;
    "set" )

        export PATH="$NODEJS_DIR/bin:$NODEJS_MODULES_DIR/.bin:$PATH"
        export NODE_PATH="$NODEJS_DIR"

    ;;
    * )
        echo "No action indicated"
    ;;

    esac

}
