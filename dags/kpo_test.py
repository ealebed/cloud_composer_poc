from airflow import models
import datetime
from kubernetes.client import models as k8s

from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import (
    KubernetesPodOperator,
)

yesterday = datetime.datetime.combine(
    datetime.datetime.today() - datetime.timedelta(1),
    datetime.datetime.min.time())

volume_mount = k8s.V1VolumeMount(
    name="dbt-volume",
    mount_path="/models",
    sub_path=None,
    # read_only=True, # TODO: Refactor, create separate mount and set RO only for dbt container
)

volume = k8s.V1Volume(
    name="dbt-volume",
    persistent_volume_claim=k8s.V1PersistentVolumeClaimVolumeSource(
        claim_name="dbt-pvc" #,
        # read_only=True        # Pod Claims for volume in read-only access mode. TODO: Refactor
    ),
)

with models.DAG(
    dag_id="my-dag",
    schedule_interval='@daily',
    catchup=False,
    start_date=yesterday
) as dag:

    dbt_clone = KubernetesPodOperator(
        namespace='dbt',
        service_account_name='dbt-sa',
        image="gcr.io/google.com/cloudsdktool/cloud-sdk:373.0.0",
        cmds=["bash", "-c", 'gsutil rsync -r gs://${GCS_BUCKET}/dags /models'],
        name="demo-cp",
        task_id="copying_new_dbt_code",
        get_logs=True,
        in_cluster=False,
        volumes=[volume],
        volume_mounts=[volume_mount],
    )

    dbt_ls = KubernetesPodOperator(
        namespace='dbt',
        image="busybox",
        cmds=["sh", "-c", 'echo \'DBT Debug run\'; cd  /models; ls -la ; echo \'Done!\''],
        name="demo-ls",
        task_id="listing_new_dbt_code",
        get_logs=True,
        in_cluster=False,
        volumes=[volume],
        volume_mounts=[volume_mount],
    )

dbt_clone >> dbt_ls
