#!/usr/bin/python3

import shutil
from entrypoint_helpers import env, gen_cfg

SSO_ENABLED = env['sso_enabled']

print("Checking for SSO env variable")
if SSO_ENABLED.lower() == 'true':
    print("Copying SSO related files")
    gen_cfg('login.ftl.j2', '/opt/atlassian/bamboo/atlassian-bamboo/login.ftl')
    shutil.copyfile("/opt/atlassian/sso/seraph-config.xml",
                    "/opt/atlassian/bamboo/atlassian-bamboo/WEB-INF/classes/seraph-config.xml")
    shutil.copyfile("/opt/atlassian/sso/crowd.properties",
                    "/var/atlassian/application-data/bamboo/xml-data/configuration/crowd.properties")

BAMBOO_INSTALL_DIR = env['bamboo_install_dir']

print("Generating server.xml file")
gen_cfg('server.xml.j2', f'{BAMBOO_INSTALL_DIR}/conf/server.xml')
