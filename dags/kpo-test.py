"""Example Airflow DAG that runs KubernetesPodOperator tasks.

First task sync files from GCS bucket to PV in GKE cluster,
second one uses updated files to run needed job (e.g. apply DBT models)
"""

# import airflow
import datetime
import os

from airflow import models
# from datetime import timedelta
# from functools import partial

from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator
import kubernetes_commons
import env_variables

DAG_ID = os.path.basename(__file__).replace(".pyc", "").replace(".py", "")

# TODO: define and use defaults
# default_args = {
#     'owner': 'OWNER_NAME',
#     'depends_on_past': False,
#     'start_date': airflow.utils.dates.days_ago(1),
#     'retry_delay': timedelta(minutes=5),
#     'on_failure_callback': partial(task_fail_alert, usr="OWNER_NAME"), # TOOD: prepare fail/success notifications
# }

yesterday = datetime.datetime.combine(
    datetime.datetime.today() - datetime.timedelta(1),
    datetime.datetime.min.time())

with models.DAG(
    DAG_ID,
    # default_args=default_args, # TODO: Use default args defined above
    max_active_runs=1,
    schedule_interval='@daily',
    catchup=False,
    start_date=yesterday
) as dag:

    dbt_sync = KubernetesPodOperator(
        namespace="dbt",
        service_account_name="dbt-sa",
        image=env_variables.SYNC_DOCKER_IMAGE,
        cmds=["bash", "-c", "gsutil rsync -r ${GCS_COMPOSER_BUCKET}/dbt /dbt"],
        name="dbt_sync",
        task_id="syncing_dbt_code",
        get_logs=True,
        is_delete_operator_pod=True,
        hostnetwork=False,
        in_cluster=False,
        do_xcom_push=False,
        env_vars=kubernetes_commons.env_vars,
        resources=kubernetes_commons.dbt_resources,
        volumes=[kubernetes_commons.dbt_volume],
        volume_mounts=[kubernetes_commons.sync_volume_mount],
    )

    dbt_run = KubernetesPodOperator(
        namespace="dbt",
        image=env_variables.DBT_DOCKER_IMAGE,
        cmds=["bash", "-c", "cd cdw_dbt ; dbt run --profiles-dir=/usr/app/dbt -m staging.auction presentation.auction"],
        name="dbt_run",
        task_id="applying_dbt_code",
        get_logs=True,
        is_delete_operator_pod=True,
        hostnetwork=False,
        in_cluster=False,
        do_xcom_push=False,
        resources=kubernetes_commons.dbt_resources,
        secrets=[kubernetes_commons.dbt_secret_volume],
        volumes=[kubernetes_commons.dbt_volume],
        volume_mounts=[kubernetes_commons.models_volume_mount],
    )

dbt_sync >> dbt_run
