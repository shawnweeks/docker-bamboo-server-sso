### Build Command
```shell
docker build \
    -t registry.cloudbrocktec.com/atlassian-suite/docker-bamboo-server-sso:7.1.1 \
    --build-arg BAMBOO_VERSION=7.1.1 \
    .
```

### Simple Run Command
```shell
docker run --init -it --rm \
    --name bamboo  \
    -p 8085:8085 \
    registry.cloudbrocktec.com/atlassian-suite/docker-bamboo-server-sso:7.1.1
```

### SSO Run Command
```shell
# Run first and setup Crowd Directory
docker run --init -it --rm \
    --name bamboo  \
    -v bamboo-data:/var/atlassian/application-data/bamboo \
    -p 8085:8085 \
    -e ATL_TOMCAT_CONTEXTPATH='/bamboo' \
    -e ATL_TOMCAT_SCHEME='https' \
    -e ATL_TOMCAT_SECURE='true' \
    -e ATL_PROXY_NAME='cloudbrocktec.com' \
    -e ATL_PROXY_PORT='443' \
    registry.cloudbrocktec.com/atlassian-suite/docker-bamboo-server-sso:7.1.1

# Run second after you've setup the crowd connection
docker run --init -it --rm \
    --name bamboo  \
    -v bamboo-data:/var/atlassian/application-data/bamboo \
    -p 8085:8085 \
    -e ATL_TOMCAT_CONTEXTPATH='/bamboo' \
    -e ATL_TOMCAT_SCHEME='https' \
    -e ATL_TOMCAT_SECURE='true' \
    -e ATL_PROXY_NAME='cloudbrocktec.com' \
    -e ATL_PROXY_PORT='443' \
    -e CROWD_SSO_ENABLED='true' \
    -e CUSTOM_SSO_LOGIN_URL='https://cloudbrocktec.com/spring-crowd-sso/saml/login' \
    -e CROWD_APP_NAME='bamboo' \
    -e CROWD_APP_PASS='bamboo' \
    -e CROWD_BASE_URL='https://cloudbrocktec.com/crowd' \
    registry.cloudbrocktec.com/atlassian-suite/docker-bamboo-server-sso:7.1.1
```

### Environment Variables
| Variable Name | Description | Default Value |
| --- | --- | --- |
| ATL_TOMCAT_PORT | The port Bamboo listens on, this may need to be changed depending on your environment. | 8085 |
| ATL_TOMCAT_SCHEME | The protocol via which Bamboo is accessed | http |
| ATL_TOMCAT_SECURE | Set to true if `ATL_TOMCAT_SCHEME` is 'https' | false |
| ATL_TOMCAT_CONTEXTPATH | The context path the application is served over | None |
| ATL_PROXY_NAME | The reverse proxys full URL for Bamboo | None |
| ATL_PROXY_PORT | The reverse proxy's port number | None |
| CUSTOM_SSO_LOGIN_URL | Login URL for Custom SSO Support | None |
| CROWD_SSO_ENABLED | Enable Crowd SSO Support |
| CROWD_APP_NAME | Crowd Application Name, Required if for Crowd SSO. | None |
| CROWD_APP_PASS | Crowd Application Password, Required if for Crowd SSO. | None |
| CROWD_BASE_URL | Crowd's Base URL | None |