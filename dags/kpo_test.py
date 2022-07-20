from airflow import models
import datetime
from kubernetes.client import models as k8s

from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import (
    KubernetesPodOperator,
)

yesterday = datetime.datetime.combine(
    datetime.datetime.today() - datetime.timedelta(1),
    datetime.datetime.min.time())

# default_dag_args = {'owner': 'airflow',
#                     'depends_on_past':False,
#                     'start_date': yesterday,
#                     'email_on_failure': False,
#                     'email_on_retry':  False,
#                     'retries': 1,
#                     'retry_delay': timedelta(minutes=5)}

volume_mount = k8s.V1VolumeMount(
    name="my-volume",
    mount_path="/models",
    sub_path=None,
    read_only=True,
)

volume = k8s.V1Volume(
    name="my-volume",
    persistent_volume_claim=k8s.V1PersistentVolumeClaimVolumeSource(
        claim_name="dbt-pvc",
        read_only=True        # Pod Claims for volume in read-only access mode.
    ),
)


with models.DAG(
    dag_id="my-dag",
    schedule_interval='@daily',
    catchup=False,
    # default_args=default_dag_args
    start_date=yesterday
) as dag:

    dbt_clone = KubernetesPodOperator(
        namespace='dbt',
        image="busybox",
        cmds=["sh", "-c", 'echo \'DBT Debug run\'; cd  /models; ls -la ; echo \'Done!\''],
        name="demo",
        task_id="copying_new_dbt_code",
        get_logs=True,
        in_cluster=False,
        volumes=[volume],
        volume_mounts=[volume_mount],
    )
