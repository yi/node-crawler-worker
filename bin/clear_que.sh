#!/bin/bash
echo "clear all que job on ${2:-localhost}:${1:-6379}"
redis-cli -p ${1:-6379} -h ${2:-localhost}  KEYS "q:*" | xargs redis-cli  -p ${1:-6379} -h ${2:-localhost} DEL
echo "DONE"


