# GCP Cloud Composer PoC

Example how to deploy GCP Cloud Composer from terraform code and run Airflow DAG that creates a Cloud Dataproc cluster, runs the Hadoop wordcount example, and deletes the Dataproc cluster.

TODO: investigate and compare current implementation with [Run Dataproc Serverless workloads with Cloud Composer](https://cloud.google.com/composer/docs/composer-2/run-dataproc-workloads)

More info:
- [Create environments with Terraform](https://cloud.google.com/composer/docs/composer-2/terraform-create-environments)
- [Running a Hadoop wordcount job on a Dataproc cluster](https://cloud.google.com/composer/docs/tutorials/hadoop-wordcount-job#airflow-2_1)
- [Test, synchronize, and deploy your DAGs using version control](https://cloud.google.com/composer/docs/dag-cicd-integration-guide)

## Getting started with Google Cloud Platform (optional)

Install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/install-sdk)

### Create project (optional)
```bash
PROJECT_ID=new-project-id
PROJECT_NAME="New project name"

gcloud projects create $PROJECT_ID --name=$PROJECT_NAME
```

If project already exist, you can get `project id`:
```bash
export PROJECT_ID=$(gcloud config get-value project 2> /dev/null)
```

and define `project id` under environment variable PROJECT_ID:
```bash
export PROJECT_ID=new-project-id
```
---

### Enable necessary API's in GCP

Enable API
```bash
gcloud services enable \
  serviceusage.googleapis.com \
  cloudresourcemanager.googleapis.com \
  --project ${PROJECT_ID}
```

For enabling all required APIs (file `gcp_apis.list`) just run bash script `gcp_enable_apis.sh`:
```bash
bash scripts/gcp_enable_apis.sh
```
---
<details>
<summary style="font-size:14px">Script</summary>
<p>

```bash
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
```
</p></details>

---

### Create service account

Define Service Account name under environment variable SA_NAME:
```bash
export SA_NAME=sa-terraform
```

Create Service Account:
```bash
gcloud iam service-accounts create ${SA_NAME} \
  --display-name "Terraform Admin Account"
```

### Grant service account necessary roles

Run script `scripts/gcp_sa_role_assignment.sh` with two arguments - `service_account_name` and  `project_id`:
```bash
bash scripts/gcp_sa_role_assignment.sh ${SA_NAME} ${PROJECT_ID}
```

### Create and download JSON credentials

Define Service Account keyfile name under environment variable SA_KEYFILE_NAME:
```bash
export SA_KEYFILE_NAME=credentials
```

Create and download Service Account Key:
```bash
gcloud iam service-accounts keys create ${SA_KEYFILE_NAME}.json \
  --iam-account ${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
```

---
<details>
<summary style="font-size:14px">Script</summary>
<p>

```bash
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
```
</p></details>

---

### Activate service account in CLI (optional)

To work with GCP Project from local CLI unders Service account, activate it
```bash
gcloud auth activate-service-account \
  ${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
  --key-file=./${SA_KEYFILE_NAME}.json \
  --project=$PROJECT_ID
```
