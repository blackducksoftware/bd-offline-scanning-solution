#!/usr/bin/env python

'''
Created on May 8, 2020

@author: gsnyder

Create Project Version custom fields on a Black Duck server using the REST API

'''


import argparse
import json
import logging
import sys

from blackduck.HubRestApi import HubInstance

logging.basicConfig(format='%(asctime)s:%(levelname)s:%(message)s', stream=sys.stderr, level=logging.DEBUG)
logging.getLogger("requests").setLevel(logging.DEBUG)
logging.getLogger("urllib3").setLevel(logging.WARNING)


hub = HubInstance()

custom_fields = [
    { "object": "Project Version", "label": "Build ID", "description": "Build ID", "type":"TEXT", "position":0},
    { "object": "Project Version", "label": "Commit ID", "description": "Commit ID", "type":"TEXT", "position":0},
    { "object": "Project Version", "label": "Branch", "description": "Branch", "type":"TEXT", "position":0},
    { "object": "Project Version", "label": "Build Server", "description": "Build server URL or ID", "type":"TEXT", "position":0},
]

for cf in custom_fields:
    logging.debug("Creating custom field {}".format(cf))
    response = hub.create_cf(
            cf['object'],
            cf['type'],
            cf['description'],
            cf['label'],
            cf['position'],
            active=True,
            initial_options=cf.get('initial_options', []),
        )
    logging.info("Result of creating custom object ({}) was: {}".format(cf, response.status_code))