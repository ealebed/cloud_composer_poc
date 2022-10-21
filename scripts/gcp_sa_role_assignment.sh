#!/usr/bin/env bash

SA_NAME=$1
PROJECT_ID=$2
DIR=$( dirname "${BASH_SOURCE[0]}" )
ROLES_LIST=$(cat ${DIR}/$1.roles.list)

for EACH in ${ROLES_LIST}
do
  gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
    --role ${EACH}
done
