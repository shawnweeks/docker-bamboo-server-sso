#!/bin/bash

# Normally this would be the actual start-up script.
# Atlassian didn't use Python for the Bamboo Docker image
# and I'm not going to rework their shell script at the moment.
# This just contains our script to copy the SSO files and generate
# the Tomcat server.xml and login.ftl files with our passed environmental variables.
/entrypoint.py

# Atlassian start-up script for Bamboo.
/entrypoint.sh
