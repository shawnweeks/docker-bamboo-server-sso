# Atlassian Docker UIDs
# These are based on the UIDs found in the Official Images
# to maintain compatability as much as possible.
# Jira          2001
# Confluence    2002
# Bitbucket     2003
# Crowd         2004
# Bamboo        2005

ARG BASE_REGISTRY=registry.cloudbrocktec.com
ARG BASE_IMAGE=redhat/ubi/ubi8
ARG BASE_TAG=8.2

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

ENV BAMBOO_USER bamboo
ENV BAMBOO_GROUP bamboo
ENV BAMBOO_UID 2005
ENV BAMBOO_GID 2005

ENV BAMBOO_HOME /var/atlassian/application-data/bamboo
ENV BAMBOO_INSTALL_DIR /opt/atlassian/bamboo

ARG BAMBOO_VERSION
ARG DOWNLOAD_URL=https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz

RUN yum install -y java-1.8.0-openjdk-devel python3 python3-jinja2

COPY [ "entrypoint.sh", "/tmp/scripts/" ]

RUN mkdir -p ${BAMBOO_HOME} && \
    mkdir -p ${BAMBOO_INSTALL_DIR} && \
    groupadd -r -g ${BAMBOO_GID} ${BAMBOO_GROUP} && \
    useradd -r -u ${BAMBOO_UID} -g ${BAMBOO_GROUP} -M -d ${BAMBOO_HOME} ${BAMBOO_USER} && \
    curl --silent -L ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "$BAMBOO_INSTALL_DIR" && \
    echo "bamboo.home=${BAMBOO_HOME}" > $BAMBOO_INSTALL_DIR/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties && \
    chown -R "${BAMBOO_USER}:${BAMBOO_GROUP}" "${BAMBOO_INSTALL_DIR}" && \
    cp /tmp/scripts/* ${BAMBOO_HOME} && \
    chown -R "${BAMBOO_USER}:${BAMBOO_GROUP}" "${BAMBOO_HOME}" && \
    chmod 755 ${BAMBOO_HOME}/*.sh

ENV BAMBOO_JMS_CONNECTION_PORT=54663
EXPOSE 8085
EXPOSE $BAMBOO_JMS_CONNECTION_PORT

VOLUME ${BAMBOO_HOME}
USER ${BAMBOO_USER}
WORKDIR ${BAMBOO_HOME}
ENTRYPOINT [ "./entrypoint.sh" ]