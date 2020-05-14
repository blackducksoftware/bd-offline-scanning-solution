#!/usr/bin/env python

'''
Created on May 8, 2020

@author: gsnyder

Upload a set of off-line/dry-run scans to a BD server using the REST API
    and also custom field values for the project-version where the scans 
    will be mapped to

'''


import argparse
import json
import logging
import os
import sys
import uuid

from blackduck.HubRestApi import HubInstance, object_id

parser = argparse.ArgumentParser("Upload offline or dry-run scans to a BD server using the REST API")
parser.add_argument("scan_files", nargs='+', help="List of scan files to upload")
parser.add_argument("-c", "--custom_field_file", help="The name of a JSON-formatted file with custom field values in it that go with the scan data")
parser.add_argument("-p", "--project", help="Override the name of the project to map the scans to, and optionally apply custom field values to")
parser.add_argument("-v", "--version", help="Override the name of the version to map the scans to, and optionally apply custom field values to")
parser.add_argument("-k", "--keep", action='store_true', help="Keep any temporary file(s) created - useful for debug")
args = parser.parse_args()

logging.basicConfig(format='%(asctime)s:%(levelname)s:%(message)s', stream=sys.stderr, level=logging.DEBUG)
logging.getLogger("requests").setLevel(logging.WARNING)
logging.getLogger("urllib3").setLevel(logging.WARNING)

hub = HubInstance()

for file in args.scan_files:
    temp_file = False
    with open(file, 'r') as f:
        scan_data = json.load(f)
        #
        # Check for and execute project, version overrides
        #
        if args.project:
            logging.debug("overriding project name {} with {}".format(scan_data['project'], args.project))
            scan_data['project'] = args.project
        if args.version:
            logging.debug("overriding version name {} with {}".format(scan_data['release'], args.version))
            scan_data['release'] = args.version
        if args.project or args.version:
            file, file_extension = os.path.splitext(file)
            file_to_upload = str(uuid.uuid4()) + file_extension
            with open(file_to_upload, 'w') as f:
                json.dump(scan_data, f, indent=3)
                temp_file = True
            msg = "Uploading scan file {} using temporary file {} which is being mapped to project {}, version {}".format(
                file, file_to_upload, scan_data['project'], scan_data['release'])
        else:
            file_to_upload = file
            msg = "Uploading scan file {} which is being mapped to project {}, version {}".format(
                file, scan_data['project'], scan_data['release'])
        #
        # Upload the scan file
        #
        logging.debug(msg)
        logging.debug(hub.upload_scan(file_to_upload))
        if temp_file and not args.keep:
            logging.debug("removing temp file {}".format(file_to_upload))
            os.remove(file_to_upload)
        elif temp_file:
            logging.debug("preserving temp file {}".format(file_to_upload))

#
# Upload custom field values to the Project-version
#
if args.custom_field_file:
    with open(args.custom_field_file, 'r') as f:
        custom_field_data = json.load(f)

        #
        # Find the project-version object using the project and version name
        # or the override values provided
        #
        project_name = args.project if args.project else custom_field_data['project']
        version_name = args.version if args.version else custom_field_data['version']
        # remove values not needed to update
        del custom_field_data['project']
        del custom_field_data['version']

        # at this point the project-version should exist due to the uploading of scans
        pv_obj = hub.get_project_version_by_name(project_name, version_name)
        pv_custom_fields = hub.get_cf_values(pv_obj).get('items', [])

        #
        # For each label found in the custom field data we look for a
        # custom field with that label, and if we find one, we update it
        #
        for label,new_value in custom_field_data.items():
            cf_to_modify = None
            for cf in pv_custom_fields:
                if cf['label'].lower() == label.lower():
                    cf_to_modify = cf
                    break

            if cf_to_modify:
                logging.debug("Updating custom field {} with value {}".format(cf_to_modify, new_value))
                cf_to_modify['values'] = [new_value]
                url = cf_to_modify['_meta']['href']
                response = hub.put_cf_value(url, cf_to_modify)
                if response.status_code == 200:
                    logging.info("succeeded updating custom field {} at {} with new value {}".format(
                        label, pv_obj['_meta']['href'], new_value))
                else:
                    logging.error("succeeded updating custom field {} at {} with new value {}. status code returned was: {}".format(
                        label, pv_obj['_meta']['href'], new_value, response.status_code))
            else:
                logging.error("Failed to find a custom field with label={} at {}".format(
                    label, pv_obj['_meta']['href']))
