"""Example Airflow DAG that runs KubernetesPodOperator tasks.

Task run needed job (e.g. apply DBT models)
"""

import datetime
import os

from airflow import models

from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator
import kubernetes_commons

DAG_ID = os.path.basename(__file__).replace(".pyc", "").replace(".py", "")

yesterday = datetime.datetime.combine(
    datetime.datetime.today() - datetime.timedelta(1),
    datetime.datetime.min.time())

with models.DAG(
    DAG_ID,
    max_active_runs=1,
    schedule_interval='@daily',
    catchup=False,
    start_date=yesterday
) as dag:

    dbt_run = KubernetesPodOperator(
        namespace="dbt",
        image="us-west1-docker.pkg.dev/new-project-id/docker/dbt-project:22-10-21--08-26",
        cmds=[
            "sh",
            "-c",
            f"dbt run -m {model} --vars='{vars_json}' --target {self.env}"
        ],
        name="dbt_run",
        task_id="applying_dbt_code",
        get_logs=True,
        is_delete_operator_pod=True,
        hostnetwork=False,
        in_cluster=False,
        do_xcom_push=False,
        resources=kubernetes_commons.dbt_resources,
        secrets=[kubernetes_commons.dbt_secret_volume],
    )

dbt_run
