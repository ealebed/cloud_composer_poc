#!/usr/bin/env bash

DIR=$( dirname "${BASH_SOURCE[0]}" )
API_LIST=$(cat ${DIR}/gcp_api.list)

for EACH in ${API_LIST}
do 
    gcloud services enable ${EACH} --project ${PROJECT_ID}
    if [[ $? == 0 ]]
    then
        echo "API ${EACH} enabled"
    else
        echo "Error during enabling ${EACH}"
        exit
    fi;
done
