#!/bin/bash

mkdir -p log
mkdir -p output-md
kill `cat ./log/crawler-worker-md.pid`
node lib/crawler-worker.js -g "md" -p 6379 -h localhost  -o output-md/ > log/crawler-worker-md.log 2>&1 &
echo $!>./log/crawler-worker-md.pid
tail -f ./log/crawler-worker-md.log

