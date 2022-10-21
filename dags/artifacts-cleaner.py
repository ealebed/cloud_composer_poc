""" Airflow DAG that runs KubernetesPodOperator task.

Task gcr-cleaner deletes old container images in Artifact Registry.

This can help reduce storage costs, especially in CI/CD environments
where images are created and pushed frequently.
"""

import datetime
import os
import yaml

from airflow import models

from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator

DAG_ID = os.path.basename(__file__).replace(".pyc", "").replace(".py", "")

default_args = {
    'depends_on_past': False,
    'email': [],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': datetime.timedelta(minutes=5),
    'owner': 'CLOUD_OPS',
}

GCP_REGION = "us-west1"
PROJECT_ID = "new-project-id"
REPOSITORY = "docker"
IMAGE_NAME = "dbt-project"

REPO_URL =  f"{GCP_REGION}-docker.pkg.dev/{PROJECT_ID}/{REPOSITORY}/{IMAGE_NAME}"

yesterday = datetime.datetime.combine(
    datetime.datetime.today() - datetime.timedelta(1),
    datetime.datetime.min.time())

with models.DAG(
    DAG_ID,
    default_args=default_args,
    max_active_runs=1,
    schedule_interval='@daily',
    catchup=False,
    start_date=yesterday,
    # Docker images have tags like '22-10-21--08-26'
    params={
        "tag_version": models.Param((datetime.datetime.today() - datetime.timedelta(7)).strftime("%y.%m.%d."), type='string'),
    },
    tags=["gcr", "maintenance"]
) as dag:

    TAG_REGEX = "{{ params.tag_version }}"

    gcr_cleaner = KubernetesPodOperator(
        namespace="dbt",
        service_account_name="gcr-cleaner-sa",
        image="us-docker.pkg.dev/gcr-cleaner/gcr-cleaner/gcr-cleaner-cli",
        arguments=["-repo", f"{REPO_URL}", f"-tag-filter-all={TAG_REGEX}"],
        name="gcr_cleaner",
        task_id="gcr_cleaner_task",
        get_logs=True,
        is_delete_operator_pod=True,
        hostnetwork=False,
        in_cluster=False,
        do_xcom_push=False,
    )

gcr_cleaner
