#!/bin/sh

cd app

if [[ ! -f healthcheck.sh ]]; then
    ./healthcheck.sh
    exit $?
fi