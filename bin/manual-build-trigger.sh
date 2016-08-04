#!/usr/bin/env bash

usage(){
    echo "$0 <concourse_target_name> <pipeline_name>"
    echo "  => concourse_target_name: [$(for i in $(grep -e "^  \w.*" ~/.flyrc|cut -d':' -f1); do echo -n $i' ';done)]"
    echo "  => pipeline_name: [ $(for filename in $(basename -s .yml -a $(ls pipelines/*.yml)); do echo -n $filename' ';done)]"

    exit 1
}

if [ $# -ne 2 ]
then
	usage
fi

CONCOURSE_TARGET_NAME=$1
PIPELINE_NAME=$2



for job in $(grep -e '^- name:' pipelines/$2.yml|cut -d':' -f2)
do
    fly -t $CONCOURSE_TARGET_NAME trigger-job -j $PIPELINE_NAME/$job
done