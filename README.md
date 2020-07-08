# Bamboo Crowd SSO
This is taken from Atlassians Bamboo Docker repo and customized to support our need for SSO through a custom login application.

## Build
```shell
docker build -t bamboo-server-sso --build-arg BAMBOO_VERSION=7.0.4 .
```

## Remote Agent Settings

* `BROKER_CLIENT_URI` (default: tcp://localhost:54663)

   Sets the Broker client URI that remote bamboo agents will use.

## SSO Settings

* `SSO_ENABLED` (default: false)

   Enables Crowd SSO.

* `SSO_URL` (default: NONE)

   The URL to perform the SSO login process.

## Reverse Proxy Settings

* `ATL_PROXY_NAME` (default: NONE)

   The reverse proxy's fully qualified hostname. `CATALINA_CONNECTOR_PROXYNAME`
   is also supported for backwards compatability.

* `ATL_PROXY_PORT` (default: NONE)

   The reverse proxy's port number via which Jira is
   accessed. `CATALINA_CONNECTOR_PROXYPORT` is also supported for backwards
   compatability.

* `ATL_TOMCAT_PORT` (default: 8085)

   The port for Tomcat/Jira to listen on. Depending on your container
   deployment method this port may need to be
   [exposed and published][docker-expose].

* `ATL_TOMCAT_SCHEME` (default: http)

   The protocol via which Jira is accessed. `CATALINA_CONNECTOR_SCHEME` is also
   supported for backwards compatability.

* `ATL_TOMCAT_SECURE` (default: false)

   Set 'true' if `ATL_TOMCAT_SCHEME` is 'https'. `CATALINA_CONNECTOR_SECURE` is
   also supported for backwards compatability.

* `ATL_TOMCAT_CONTEXTPATH` (default: NONE)

# Original Bamboo Readme
Bamboo is a continuous integration and continuous deployment server. Learn more about [Bamboo](<https://www.atlassian.com/software/bamboo>).

If you are looking for **Bamboo Agent Docker Image** it can be found [here](https://hub.docker.com/r/atlassian/bamboo-agent-base/).

# Overview

This Docker container makes it easy to get an instance of Bamboo up and running.

**We strongly recommend you run this image using a specific version tag instead of latest. This is because the image referenced by the latest tag changes often and we cannot guarantee that it will be backwards compatible.**

# Quick Start

For the `BAMBOO_HOME` directory that is used to store, among other things, the configuration data
 we recommend mounting a host directory as a [data volume](https://docs.docker.com/engine/tutorials/dockervolumes/#/data-volumes), or using a named volume. 

Volume permission is managed by entry scripts. To get started you can use a data volume, or named volumes. In this example we'll use named volumes.

    $> docker volume create --name bambooVolume
    $> docker run -v bambooVolume:/var/atlassian/application-data/bamboo --name="bamboo" --init -d -p 54663:54663 -p 8085:8085 atlassian/bamboo-server

Note that this command can be replaced by named volumes.

Start Atlassian Bamboo:

    $> docker run -v /data/bamboo:/var/atlassian/application-data/bamboo --name="bamboo-server" --host=bamboo-server --init -d -p 54663:54663 -p 8085:8085 atlassian/bamboo-server

**Success**. Bamboo is now available on [http://localhost:8085](http://localhost:8085)*.

**Note that the `--init` flag is required to properly reap zombie processes.**

Make sure your container has the necessary resources allocated to it.
We recommend 2GiB of memory allocated to accommodate the application server.
See [Supported Platforms](https://confluence.atlassian.com/display/Bamboo/Supported+platforms) for further information.

## JVM Configuration

If you need to override Bamboo's default memory configuration or pass additional JVM arguments, use the environment variables below

* `JVM_MINIMUM_MEMORY` (default: 512m)

   The minimum heap size of the JVM

* `JVM_MAXIMUM_MEMORY` (default: 1024m)

   The maximum heap size of the JVM

* `JVM_SUPPORT_RECOMMENDED_ARGS` (default: NONE)

   Additional JVM arguments for Bamboo, such as a custom Java Trust Store

# Upgrade

To upgrade to a more recent version of Bamboo you can simply stop the `bamboo`
container and start a new one based on a more recent image:

    $> docker stop bamboo
    $> docker rm bamboo
    $> docker pull atlassian/bamboo-server:<desired_version>
    $> docker run ... (See above)

As your data is stored in the data volume directory on the host it will still
be available after the upgrade.

_Note: Please make sure that you **don't** accidentally remove the `bamboo`
container and its volumes using the `-v` option._

# Backup

For evaluations you can use the built-in database that will store its files in the Bamboo home directory. In that case it is sufficient to create a backup archive of the directory on the host that is used as a volume (`/data/bamboo` in the example above).

# Versioning

The `latest` tag matches the most recent version of this repository. Thus using `atlassian/bamboo-server:latest` or `atlassian/bamboo-server` will ensure you are running the most up to date version of this image.

However,  we **strongly recommend** that for non-eval workloads you select a specific version in order to prevent breaking changes from impacting your setup.
You can use a specific minor version of Bamboo by using a version number tag: `atlassian/bamboo-server:6.7`. This will install the latest `6.7.x` stable version that is available.

# Running Bamboo Server with a Remote Agent

If you want to run Bamboo Server and Agent containers on one host (in one Docker engine), you will need to create a Docker network for them:

    $> docker network create bamboo

You can start Bamboo Server and Agent using following commands:

    $> docker run -v bambooVolume:/var/atlassian/application-data/bamboo --name bamboo-server --network bamboo --hostname bamboo-server --init -d -p 8085:8085 atlassian/bamboo-server
    $> docker run -v bambooAgentVolume:/home/bamboo/bamboo-agent-home --name bamboo-agent --network bamboo --hostname bamboo-agent --init -d atlassian/bamboo-agent-base http://bamboo-server:8085

# Support

For image and product support, go to [support.atlassian.com](https://support.atlassian.com/).

# Change log

## 6.7.1

Repository-stored Specs (RSS) are no longer processed in Docker by default. Running RSS in Docker was not possible because:

* there is no Docker capability added on the Bamboo server by default,
* the setup would require running Docker in Docker.

The change will affect fresh Bamboo installations. Upgrades and XML imports will still require the RSS settings to be
changed manually in *Administration* &rarr; *Security settings*.

Tomcat was upgraded to version 8.5.32. Default security settings were made more strict for umask, instead of 0022 it's 0027. If you want to keep same behavior use "-e UMASK=0022" variable when run Docker image, e.g.

    $> docker run -d --name=bamboo671  -p 8085:8085 -p 54663:54663 -e UMASK=0022 -v bambooVolume:/var/atlassian/application-data/bamboo atlassian/bamboo-server:6.7.1

## 7.0

* Base image changed to `adoptopenjdk:8-jdk-hotspot-bionic`
* Improved image's layering
