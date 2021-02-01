#!/bin/bash

set -e
umask 0027

# Bamboo should not run Repository-stored Specs in Docker while being run in a Docker container itself.
# Only affects the installation phase. Has no effect once Bamboo is set up.
CATALINA_OPTS="${CATALINA_OPTS} -Dbamboo.setup.rss.in.docker=false"

export JVM_SUPPORT_RECOMMENDED_ARGS=${ATL_JAVA_ARGS}
export JVM_MINIMUM_MEMORY=${ATL_MIN_MEMORY}
export JVM_MAXIMUM_MEMORY=${ATL_MAX_MEMORY}

entrypoint.py

unset "${!ATL_@}"

set +e
flock -x -w 30 ${HOME}/.flock ${BAMBOO_INSTALL_DIR}/bin/start-bamboo.sh -fg &
BAMBOO_PID="$!"

echo "Bamboo Started with PID ${BAMBOO_PID}"
wait ${BAMBOO_PID}

if [[ $? -eq 1 ]]
then
    echo "Bamboo Failed to Aquire Lock! Exiting"
    exit 1
fi