from kubernetes.client import models as k8s
from airflow.kubernetes.secret import Secret

# Default resources for tasks running in k8s cluster
dbt_resources = k8s.V1ResourceRequirements(
    requests={
        'memory': '1Gi',
        'cpu': 1,
        'ephemeral-storage': '1Gi'
    },
    limits={
        'memory': '1Gi',
        'cpu': 1,
        'ephemeral-storage': '1Gi'
    }
)
# Secret with SA key
# JUST FOR DEMO
dbt_secret_volume = Secret(
    deploy_type='volume',
    # Path where we mount the secret as volume
    deploy_target='/root/gcp',
    # Name of Kubernetes Secret
    secret='composer-keyfile',
    # Key in the form of service account file name
    key='keyfile.json')
