# Atlassian Docker UIDs
# These are based on the UIDs found in the Official Images
# to maintain compatability as much as possible.
# Jira          2001
# Confluence    2002
# Bitbucket     2003
# Crowd         2004
# Bamboo        2005
ARG BASE_REGISTRY
ARG BASE_IMAGE=redhat/ubi/ubi7
ARG BASE_TAG=7.9

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as build

ARG BAMBOO_VERSION
ARG BAMBOO_PACKAGE=atlassian-bamboo-${BAMBOO_VERSION}.tar.gz

COPY [ "${BAMBOO_PACKAGE}", "/tmp/" ]

RUN mkdir -p /tmp/atl_pkg && \
    tar -xf /tmp/${BAMBOO_PACKAGE} -C "/tmp/atl_pkg" --strip-components=1


###############################################################################
ARG BASE_REGISTRY
ARG BASE_IMAGE=redhat/ubi/ubi7
ARG BASE_TAG=7.9

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

ENV BAMBOO_USER bamboo
ENV BAMBOO_GROUP bamboo
ENV BAMBOO_UID 2005
ENV BAMBOO_GID 2005

ENV BAMBOO_HOME /var/atlassian/application-data/bamboo
ENV BAMBOO_INSTALL_DIR /opt/atlassian/bamboo

RUN yum install -y java-1.8.0-openjdk-devel python2 python2-jinja2 && \
    yum clean all && \    
    mkdir -p ${BAMBOO_HOME} && \
    mkdir -p ${BAMBOO_INSTALL_DIR} && \
    groupadd -r -g ${BAMBOO_GID} ${BAMBOO_GROUP} && \
    useradd -r -u ${BAMBOO_UID} -g ${BAMBOO_GROUP} -M -d ${BAMBOO_HOME} ${BAMBOO_USER} && \
    chown ${BAMBOO_USER}:${BAMBOO_GROUP} ${BAMBOO_HOME} && \
    chown ${BAMBOO_USER}:${BAMBOO_GROUP} ${BAMBOO_INSTALL_DIR}

COPY [ "templates/*.j2", "/opt/jinja-templates/" ]
COPY --from=build --chown=${BAMBOO_USER}:${BAMBOO_GROUP} [ "/tmp/atl_pkg", "${BAMBOO_INSTALL_DIR}/" ]
COPY --chown=${BAMBOO_USER}:${BAMBOO_GROUP} [ "entrypoint.sh", "entrypoint.py", "entrypoint_helpers.py", "${BAMBOO_INSTALL_DIR}/" ]


RUN echo "bamboo.home=${BAMBOO_HOME}" > $BAMBOO_INSTALL_DIR/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties && \
    chmod 755 ${BAMBOO_INSTALL_DIR}/entrypoint.*

EXPOSE 8085
EXPOSE 54663

VOLUME ${BAMBOO_HOME}
USER ${BAMBOO_USER}
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0
ENV PATH=${PATH}:${BAMBOO_INSTALL_DIR}
WORKDIR ${BAMBOO_HOME}
ENTRYPOINT [ "entrypoint.sh" ]