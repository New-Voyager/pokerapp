#!/usr/bin/env bash

set -e

if [ -z "${DOCKER_NET}" ]; then
    echo "DOCKER_NET is not defined"
    exit 1
fi

if [ -z "${BOTRUNNER_IMAGE}" ]; then
    echo "BOTRUNNER_IMAGE is not defined"
    exit 1
fi

if [ -z "${BOTRUNNER_SCRIPT}" ]; then
    echo "BOTRUNNER_SCRIPT is not defined"
    exit 1
fi

docker run -t --rm \
    --name botrunner \
    --network=${DOCKER_NET} \
    -e API_SERVER_URL=http://api-server:9501 \
    -e NATS_HOST=nats \
    -e NATS_CLIENT_PORT=4222 \
    -e PRINT_GAME_MSG=false \
    -e PRINT_HAND_MSG=false \
    -v ${PWD}/botrunner_scripts:/app/botrunner_scripts \
    ${BOTRUNNER_IMAGE} \
    sh -c "./botrunner --config ./botrunner_scripts/${BOTRUNNER_SCRIPT}"
