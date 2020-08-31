#!/usr/bin/python3

from entrypoint_helpers import env, gen_cfg

BAMBOO_HOME = env['BAMBOO_HOME']
BAMBOO_INSTALL_DIR = env['BAMBOO_INSTALL_DIR']

gen_cfg('server.xml.j2', f'{BAMBOO_INSTALL_DIR}/conf/server.xml')


if 'CROWD_SSO_ENABLED' in env and env['CROWD_SSO_ENABLED'] == 'true':
    gen_cfg('login.ftl.j2',         f'{BAMBOO_INSTALL_DIR}/atlassian-bamboo/login.ftl')
    gen_cfg('seraph-config.xml.j2', f'{BAMBOO_INSTALL_DIR}/atlassian-bamboo/WEB-INF/classes/seraph-config.xml')
    gen_cfg('crowd.properties.j2',  f'{BAMBOO_HOME}/xml-data/configuration/crowd.properties')