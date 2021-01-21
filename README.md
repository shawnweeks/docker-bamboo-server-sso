### Download Files
```shell
export BAMBOO_VERSION=7.1.4
wget https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz
```

### Build Command
```shell
export BAMBOO_VERSION=7.1.4
docker build \
    -t ${REGISTRY}/atlassian-suite/bamboo-server-sso:${BAMBOO_VERSION} \
    --build-arg BASE_REGISTRY=${REGISTRY} \
    --build-arg BAMBOO_VERSION=${BAMBOO_VERSION} \
    .
```

### Push to Registry
```shell
docker push ${REGISTRY}/atlassian-suite/bamboo-server-sso
```

### Simple Run Command
```shell
export BAMBOO_VERSION=7.1.4
docker run --init -it --rm \
    --name bamboo  \
    -v bamboo-data:/var/atlassian/application-data/bamboo \
    -p 8085:8085 \
    ${REGISTRY}/atlassian-suite/bamboo-server-sso:${BAMBOO_VERSION}
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
    ${REGISTRY}/atlassian-suite/bamboo-server-sso:7.1.1

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
    ${REGISTRY}/atlassian-suite/bamboo-server-sso:7.1.1
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

### Additional
#### Auto-login
By default when SSO is enabled, the app will automatically redirect to the SSO login app when the user hits the login page. This can be disabled by passing a query paramter in the login page URL. `auto_login=false`

Too prevent login redirect loops, a cookie is created when the user first hits the login page. Any hits on the login page within one minute afterwards will require the user to click a link to initiate a login.