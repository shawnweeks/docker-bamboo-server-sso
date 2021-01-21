#!/bin/bash

set -e
umask 0027

# Bamboo should not run Repository-stored Specs in Docker while being run in a Docker container itself.
# Only affects the installation phase. Has no effect once Bamboo is set up.
CATALINA_OPTS="${CATALINA_OPTS} -Dbamboo.setup.rss.in.docker=false"

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

export JAVA_OPTS="${JAVA_OPTS}"
export CATALINA_OPTS="${CATALINA_OPTS}"

shutdownCleanup() {
    # Currently it looks like Bamboo doesn't lock it's home
    # directory but I'm leaving this in here anyway.
    if [[ -f ${HOME}/.lock ]]
    then
        echo "Cleaning Up Bamboo Lock"
        rm ${HOME}/.lock
    fi
}

entrypoint.py
trap "shutdownCleanup" INT
${BAMBOO_INSTALL_DIR}/bin/start-bamboo.sh -fg