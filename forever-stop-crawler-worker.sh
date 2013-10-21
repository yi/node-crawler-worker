#!/bin/bash


# Get absolute path of script
pushd `dirname $0` > /dev/null
GS_PATH=`pwd`
CONF_PATH=$GS_PATH/gs.js
popd > /dev/null

mkdir -p ~/log
mkdir -p $PATH_OUTPUT_WEB_PAGES
touch $GS_PATH/log/crawler-worker.log

forever stop -a $GS_PATH/lib/crawler-worker.js 2>> $GS_PATH/log/crawler-worker.log
echo "Forever STOP: crawler-worker --- DONE."


