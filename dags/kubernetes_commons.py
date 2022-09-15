from kubernetes.client import models as k8s
from airflow.kubernetes.secret import Secret
import env_variables

# TODO: Default affinity for tasks running in k8s cluster
# dbt_affinity = k8s.V1Affinity(
#     node_affinity=k8s.V1NodeAffinity(
#         preferred_during_scheduling_ignored_during_execution=[
#             k8s.V1PreferredSchedulingTerm(
#                 weight=1,
#                 preference=k8s.V1NodeSelectorTerm(
#                     match_expressions=[
#                         k8s.V1NodeSelectorRequirement(key="app", operator="In", values=["dbt"])
#                     ]
#                 ),
#             )
#         ]
#     ),
# )

# TODO: Default tolerations for tasks running in k8s cluster
# dbt_tolerations = [k8s.V1Toleration(effect="NoSchedule", key="app", operator="Equal", value="dbt")]

# Default resources for tasks running in k8s cluster
dbt_resources = k8s.V1ResourceRequirements(
    requests={
        'memory': '2Gi',
        'cpu': 1,
        'ephemeral-storage': '1Gi'
    },
    limits={
        'memory': '2Gi',
        'cpu': 1,
        'ephemeral-storage': '2Gi'
    }
)

# Secret with SA key for authorization in BigQuery
dbt_secret_volume = Secret(
    deploy_type='volume',
    # Path where we mount the secret as volume
    deploy_target='/root/.dbt',
    # Name of Kubernetes Secret
    secret='dbt-keyfile',
    # Key in the form of service account file name
    key='keyfile.json')

# DBT volume
dbt_volume = k8s.V1Volume(
    name="dbt-volume",
    persistent_volume_claim=k8s.V1PersistentVolumeClaimVolumeSource(
        claim_name="dbt-pvc"
    ),
)

# DBT volume mount in 'sync' pod
sync_volume_mount = k8s.V1VolumeMount(
    name="dbt-volume",
    mount_path="/dbt",
    sub_path=None,
)

# DBT volume mount in 'dbt' pod
models_volume_mount = k8s.V1VolumeMount(
    name="dbt-volume",
    mount_path="/usr/app/dbt",
    sub_path=None,
)

# Example setting/usage ENV inside KPO
env_vars = [
    k8s.V1EnvVar(
        name="GCS_COMPOSER_BUCKET",
        value=env_variables.GCS_COMPOSER_BUCKET
    )
]
