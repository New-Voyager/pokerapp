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

API_SERVER_URL=http://api-server:9501
GAME_SERVER_URL=http://game-server:8080

docker run -t --rm \
    --name botrunner \
    --network=${DOCKER_NET} \
    -e API_SERVER_URL=${API_SERVER_URL} \
    -e PRINT_GAME_MSG=${PRINT_GAME_MSG:-true} \
    -e PRINT_HAND_MSG=${PRINT_HAND_MSG:-true} \
    -v ${PWD}/botrunner_scripts:/app/botrunner_scripts \
    ${BOTRUNNER_IMAGE} \
    sh -c "\
        while ! curl -s ${API_SERVER_URL} >/dev/null; do \
            echo 'Waiting for API server ${API_SERVER_URL}'; \
            sleep 1; \
        done \
        && \
        while ! curl -s ${GAME_SERVER_URL} >/dev/null; do \
            echo 'Waiting for game server ${GAME_SERVER_URL}'; \
            sleep 1; \
        done \
        && \
        ./botrunner --config ./botrunner_scripts/${BOTRUNNER_SCRIPT} \
    "
