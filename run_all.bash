#!/bin/bash

TESTS=("v2019.4.3;https://ec2-3-22-202-237.us-east-2.compute.amazonaws.com;scan.cli-2019.4.3;bd-2019-4")
TESTS+=("v2019.10.3;https://ec2-18-188-63-37.us-east-2.compute.amazonaws.com;scan.cli-2019.10.3;bd-2019-10")
TESTS+=("v2019.12.1;https://ec2-52-15-191-174.us-east-2.compute.amazonaws.com;scan.cli-2019.12.1;bd-2019-12")
TESTS+=("v2020.4.0;https://ec2-18-217-189-8.us-east-2.compute.amazonaws.com;scan.cli-2020.4.0;demo-server-token")

for test in ${TESTS[@]}
do
	# echo $test
	IFS=";" read -a test_info <<< "$test"
	export BD_VERSION=${test_info[0]}
	export BD_URL=${test_info[1]}
	export SCAN_CLI_VERSION=${test_info[2]}
	export TOKEN=${test_info[3]}

	echo "Running Detect on ${BD_VERSION}"
	echo "-------------------------------"
	echo "BD_VERSION: ${BD_VERSION}"
	echo "BD_URL: ${BD_URL}"
	echo "SCAN_CLI_VERSION: ${SCAN_CLI_VERSION}"
	echo "TOKEN: ${TOKEN}"

	./run_detect_local.bash | tee "detect-${BD_VERSION}.log"
	echo "--"
	echo "--"
	echo "--"
done