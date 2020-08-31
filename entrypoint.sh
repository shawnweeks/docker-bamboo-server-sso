#!/bin/bash

set -e

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

# Bamboo should not run Repository-stored Specs in Docker while being run in a Docker container itself.
# Only affects the installation phase. Has no effect once Bamboo is set up.
CATALINA_OPTS="${CATALINA_OPTS} -Dbamboo.setup.rss.in.docker=false"

export JAVA_OPTS="${JAVA_OPTS}"
export CATALINA_OPTS="${CATALINA_OPTS}"

startup() {
    echo Starting Bamboo Server
    ${BAMBOO_INSTALL_DIR}/bin/start-bamboo.sh
    sleep 15
    tail -n +1 -F ${BAMBOO_HOME}/logs/* ${BAMBOO_INSTALL_DIR}/logs/*
}

shutdown() {
    echo Stopping Bamboo Server
    ${BAMBOO_INSTALL_DIR}/bin/stop-bamboo.sh
}

trap "shutdown" INT
entrypoint.py
startup