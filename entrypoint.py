#!/usr/bin/python3

from entrypoint_helpers import env, gen_cfg

BAMBOO_HOME = env['BAMBOO_HOME']
BAMBOO_INSTALL_DIR = env['BAMBOO_INSTALL_DIR']

gen_cfg('server.xml.j2', '{}/conf/server.xml'.format(BAMBOO_INSTALL_DIR))


if 'ATL_CROWD_SSO_ENABLED' in env and env['ATL_CROWD_SSO_ENABLED'] == 'true':
    gen_cfg('login.ftl.j2',         '{}/atlassian-bamboo/login.ftl'.format(BAMBOO_INSTALL_DIR))
    gen_cfg('seraph-config.xml.j2', '{}/atlassian-bamboo/WEB-INF/classes/seraph-config.xml'.format(BAMBOO_INSTALL_DIR))
    gen_cfg('crowd.properties.j2',  '{}/xml-data/configuration/crowd.properties'.format(BAMBOO_HOME))