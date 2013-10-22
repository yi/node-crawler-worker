#!/bin/bash


# Get absolute path of script
pushd `dirname $0` > /dev/null
GS_PATH=`pwd`
CONF_PATH=$GS_PATH/gs.js
popd > /dev/null

GS_SERVER_ID=2
CROWLER_SERVER_REDIS_HOST=localhost
CROWLER_SERVER_REDIS_PORT=6379
PATH_OUTPUT_WEB_PAGES=/tmp/crawl-output

mkdir -p ~/log
mkdir -p $PATH_OUTPUT_WEB_PAGES
touch $GS_PATH/log/crawler-worker.log
forever start -a -l $GS_PATH/log/crawler-worker.log --pidFile $GS_PATH/crawler-worker.pid $GS_PATH/lib/crawler-worker.js -g md -o $PATH_OUTPUT_WEB_PAGES
#forever start -a -l $GS_PATH/log/forever.log -o $GS_PATH/log/crawler-worker.log -e $GS_PATH/log/crawler-worker.log --pidFile $GS_PATH/crawler-worker.pid $GS_PATH/lib/crawler-worker.js -g md -o $PATH_OUTPUT_WEB_PAGES
echo "Forever start: crawler-worker --- DONE."

