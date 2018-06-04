#!/bin/bash

export GOSS_FILES_PATH=test
export GOSS_SLEEP=10

# build image
docker build -t norrkin/sonarr . || exit 1

# run some tests
i=0
time dgoss run -e UID=501 -e GID=20 norrkin/sonarr || ((i++))

exit $i