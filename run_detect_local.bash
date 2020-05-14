#!/bin/bash

# How to get detect and signature scanner (various ways, see docs for details)
#
# 1. Run detect with --detect.cleanup=false
# 2. Copy detect jar from /tmp
# 3. Copy signature scanning tool from .../blackduck/tools/Black_Duck_Scan_Installation/scan.cli-<version>
#

# Set this to your project directory
PROJECT_DIR=$(pwd)

# Set this to the directory you want to scan
DETECT_SOURCE_DIR=${PROJECT_DIR}/test_project

# Set this to where you have downloaded Detect, and the Signature scanner files
DETECT_FILES_PATH=${PROJECT_DIR}/detect_files

# Set the Black Duck version, the signature scanner version, Black Duck URL,
# the Black Duck API/User token, and the Detect version here
BD_VERSION=${BD_VERSION:-v2020.4.0}
SCAN_CLI_VERSION=${SCAN_CLI_VERSION:-scan.cli-2020.4.0}
BD_URL=${BD_URL:-https://ec2-18-217-189-8.us-east-2.compute.amazonaws.com}
TOKEN=${TOKEN:-demo-server-token}
DETECT_JAR=synopsys-detect-6.2.1.jar

DETECT_JAR_PATH=${DETECT_FILES_PATH}/${DETECT_JAR}
SIG_SCAN_PATH=${DETECT_FILES_PATH}/${SCAN_CLI_VERSION}
TOKEN_PATH=~/.bd_tokens/${TOKEN}
OUTPUT_DIR=${PROJECT_DIR}/output-dir/${BD_VERSION}
SCAN_OUTPUT_DIR=${PROJECT_DIR}/scan-output-dir/${BD_VERSION}
PROJECT_NAME=test-project
VERSION_LABEL=1.0
BRANCH_OR_VERSION_NAME=${BRANCH_NAME:-${VERSION_LABEL}}

CLEANUP=false			# default: true
OFFLINE_MODE=true   	# default: false
SEARCH_DEPTH=3  		# default: 0
AGGREGATE=false  		# defaul is false
AGGREGATE_NAME="aggregated-bom-scans"

#
# Signature Scanner Local Path: To use a local signature scanner, 
# specify the path where the signature scanner was unzipped. 
# This will likely look similar to 'scan.cli-x.y.z' and 
# includes the 'bin, icon, jre, and lib' directories of the expanded scan.cli. 

function clean() {
	# WARNING: Don't run this unless you know what you're doing
	rm -rf $1/*
}

# Make and/or clean the output directories
#
for d in "${OUTPUT_DIR}" "${SCAN_OUTPUT_DIR}"
do
	if [ ! -d "${d}" ]; then
		echo "Making output directory ${d}"
		mkdir -p "${d}"
	else
		echo "Cleaning output directory ${d}"
		clean "${d}"
	fi
done

# Refer to the Detect on-line documentation for an explanation of the options used below
# https://blackducksoftware.github.io/synopsys-detect/latest/properties/all-properties/
#

DETECT_OPTIONS="--blackduck.url=${BD_URL} \
	--blackduck.api.token=$(cat ${TOKEN_PATH}) \
	--blackduck.trust.cert=true \
	--detect.parallel.processors=-1 \
	--detect.code.location.name="${PROJECT_NAME}-${BRANCH_OR_VERSION_NAME}"
	--detect.blackduck.signature.scanner.local.path=${SIG_SCAN_PATH} \
	--detect.output.path=${OUTPUT_DIR} \
	--detect.scan.output.path=${SCAN_OUTPUT_DIR} \
	--detect.project.name=${PROJECT_NAME} \
	--detect.project.version.name=${VERSION_LABEL} \
	--detect.cleanup=${CLEANUP} \
	--blackduck.offline.mode=${OFFLINE_MODE} \
	--detect.detector.search.depth=${SEARCH_DEPTH} \
	--detect.npm.include.dev.dependencies=false \
	--logging.level.detect=DEBUG"
	# --detect.python.python3=true \
	# --detect.pip.requirements.path=./requirements.txt"

if [ "${BD_VERSION}" == "v2020.4.0" ]; then
	DETECT_OPTIONS="${DETECT_OPTIONS} --detect.blackduck.signature.scanner.individual.file.matching=ALL"
fi

if [ "${AGGREGATE}" == "true" ]; then
	DETECT_OPTIONS="${DETECT_OPTIONS} --detect.bom.aggregate.name=${AGGREGATE_NAME}"
fi

cd ${DETECT_SOURCE_DIR}

java -jar $DETECT_JAR_PATH \
	${DETECT_OPTIONS} \
	$*

# Note: Can be 0 or more BOM files generated depending on the number of package manager files
#	discovered and whether the --detect.bom.aggregate.name option is used to aggregate them

SCAN_FILES=$(find ${SCAN_OUTPUT_DIR} -name "*json")
BOM_FILES=$(find ${OUTPUT_DIR} -name "*.jsonld")
echo 
echo "Scan files generated:"
echo "${SCAN_FILES}"
echo
echo "BOM files generated:"
echo "${BOM_FILES}"

cd ..

function stage_scan_files()
{
	if [ ! -d "${BD_VERSION}" ]; then
		echo "Making directory ${BD_VERSION} to put scan files into"
		mkdir -p ${BD_VERSION}
	else
		echo "Cleaning directory ${BD_VERSION}"
		clean "${BD_VERSION}"
	fi
	echo "Copying scan files into ${BD_VERSION}"
	cp $* ${BD_VERSION}
}

function write_custom_field_values()
{
	cat > $1 <<EOF
{
	"project": "${PROJECT_NAME}",
	"version": "${VERSION_LABEL}",
	"Build ID": "${BUILD_ID:-42}",
	"Build Server": "${BUILD_SERVER:-jenkins1}",
	"Commit ID": "12345",
	"Branch": "dev-branch"
}
EOF
}

function create_manifest()
{
	custom_field_file=$1
	shift
	scan_files="["
	for scan_file in $*
	do
		scan_files+="\"${scan_file}\", "
	done
	scan_files=$(echo $scan_files | sed -e "s/,$/]/")
	cat > manifest.json <<EOF
{
	"custom_field_file":"${custom_field_file}",
	"scan_files": ${scan_files}
}
EOF
}

stage_scan_files ${SCAN_FILES} ${BOM_FILES}
cd ${BD_VERSION}

write_custom_field_values custom-field-values.json
create_manifest custom-field-values.json ${SCAN_FILES} ${BOM_FILES}

# TODO: Archive (e.g. zip) files together for pushing to Artifactory?

