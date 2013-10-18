#!/bin/bash

mkdir -p log
kill `cat ./log/crawler-worker.pid`
node lib/crawler-worker.js -g "md15" -p 6379 -h localhost -o output/ > log/crawler-worker.log 2>&1 &
echo $!>./log/crawler-worker.pid
tail -f ./log/crawler-worker.log

