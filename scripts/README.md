# Service Account Roles for creating Terraform Resources
Following table contains required roles and permissions for high-level Service Account to deploy terraform resources in related SHARED and ENVIRONMENT projects.

| Role                                                                                           | Details                                                                                                                                      |
|------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| Artifact Registry Administrator (roles/artifactregistry.admin)                                 | To create/manage Artifact Registry repositories                                                                                              |
| BigQuery Admin (roles/bigquery.admin)                                                          | To manage all BigQuery resources (data, jobs etc) within the project                                                                         |
| Cloud Build Editor (roles/cloudbuild.builds.editor)                                            | To get access to create and cancel builds                                                                                                    |
| Cloud Build Integrations Owner (roles/cloudbuild.integrationsOwner)                            | To create/delete integrations                                                                                                                |
| Cloud KMS Admin (roles/cloudkms.admin)                                                         | To manage Cloud KMS resources, except encrypt and decrypt operations                                                                         |
| Composer Administrator (roles/composer.admin)                                                  | To manage all Cloud Composer resources within the project                                                                                    |
| Compute Admin(roles/compute.admin)                                                             | To manage all Compute Engine resources                                                                                                       |
| Compute Instance Admin (beta) (roles/compute.instanceAdmin)                                    | To create, modify and delete VM instances (including managing disks)                                                                         |
| Compute Instance Admin (v1) (roles/compute.instanceAdmin.v1)                                   | To manage all Compute Engine instances, instance groups, disks, snapshots, and images                                                        |
| Compute Network Admin (roles/compute.networkAdmin)                                             | To create, modify, and delete networking resources, except for firewall rules and SSL certificates                                           |
| Compute Storage Admin (roles/compute.storageAdmin)                                             | To manage disks, images and snapshots                                                                                                        |
| Dataproc Administrator (roles/dataproc.admin)                                                  | To manage all Cloud Dataproc resources                                                                                                       |
| Dataproc Service Agent (roles/dataproc.serviceAgent)                                           | To give Dataproc Service Account access to service accounts, compute, storage, and kubernetes resources. Includes access to service accounts |
| Dataproc Worker (roles/dataproc.worker)                                                        | To get access to Cloud Dataproc resources. Intended for service accounts                                                                     |
| Environment and Storage Object Administrator (roles/composer.environmentAndStorageObjectAdmin) | To manage all Cloud Composer resources AND of the objects in buckets within the project                                                      |
| Kubernetes Engine Developer (roles/container.developer)                                        | To get access to Kubernetes API objects inside clusters                                                                                      |
| Logging Admin (roles/logging.admin)                                                            | To use all features of Cloud Logging                                                                                                         |
| Monitoring Admin (roles/monitoring.admin)                                                      | To manage all monitoring resources                                                                                                           |
| Project IAM Admin (roles/resourcemanager.projectIamAdmin)                                      | To administer allow policies on projects                                                                                                     |
| Pub/Sub Admin (roles/pubsub.admin)                                                             | To administer topics and subscriptions                                                                                                       |
| Secret Manager Admin (roles/secretmanager.admin)                                               | To administer Secret Manager resources                                                                                                       |
| Service Account Admin (roles/iam.serviceAccountAdmin)                                          | To create and manage service accounts                                                                                                        |
| Service Account Key Admin (roles/iam.serviceAccountKeyAdmin)                                   | To create, manage and rotate service account keys                                                                                            |
| Service Account Token Creator (roles/iam.serviceAccountTokenCreator)                           | To impersonate service accounts (create OAuth2 access tokens)                                                                                |
| Service Account User (roles/iam.serviceAccountUser)                                            | To run operations as the service account                                                                                                     |
| Service Usage Admin (roles/serviceusage.serviceUsageAdmin)                                     | To enable, disable, and inspect service states                                                                                               |
| Storage Admin (roles/storage.admin)                                                            | To manage all objects and buckets within the project                                                                                         |
| Storage Object Admin (roles/storage.objectAdmin)                                               | To manage (listing, creating, viewing and deleting) objects in buckets                                                                       |
| Stackdriver Accounts Editor (roles/stackdriver.accounts.editor)                                | To get read/write access for Stackdriver infrastructure                                                                                      |

# List Google APIs enabled in GCP Project
When you create a Cloud project using the Google Cloud console or Google Cloud CLI, the following APIs and services are enabled by default:
| API | Details |
| ----------- | ------------ |
| BigQuery API (bigquery.googleapis.com) | A data platform for customers to create, manage, share and query data. |
| BigQuery Storage API (bigquerystorage.googleapis.com) | |
| Cloud Datastore API (datastore.googleapis.com) | Accesses the schemaless NoSQL database to provide fully managed, robust, scalable storage for your application. |
| Cloud Debugger API (clouddebugger.googleapis.com) | Examines the call stack and variables of a running application without stopping or slowing it down. |
| Cloud Logging API (logging.googleapis.com) | Writes log entries and manages your Cloud Logging configuration. |
| Cloud Monitoring API (monitoring.googleapis.com) | Manages your Cloud Monitoring data and configurations. |
| Cloud SQL (sql-component.googleapis.com) | Google Cloud SQL is a hosted and fully managed relational database service on Google's infrastructure. |
| Cloud Storage (storage-component.googleapis.com) | Google Cloud Storage is a RESTful service for storing and accessing your data on Google's infrastructure. |
| Cloud Storage API (storage.googleapis.com) | Lets you store and retrieve potentially-large, immutable data objects. |
| Cloud Trace API (cloudtrace.googleapis.com) | Sends application trace data to Cloud Trace for viewing. Trace data is collected for all App Engine applications by default. Trace data from other applications can be provided using this API. |
| Google Cloud APIs (cloudapis.googleapis.com) | This is a meta service for Google Cloud APIs for convenience. Enabling this service enables all commonly used Google Cloud APIs for the project. By default, it is enabled for all projects created through Google Cloud Console and Google Cloud SDK, and should be manually enabled for all other projects that intend to use Google Cloud APIs. Note: disabling this service has no effect on other services. |
| Google Cloud Storage JSON API (storage-api.googleapis.com) | Lets you store and retrieve potentially-large, immutable data objects. |
| Service Management API (servicemanagement.googleapis.com) | Google Service Management allows service producers to publish their services on Google Cloud Platform so that they can be discovered and used by service consumers. |
| Service Usage API (serviceusage.googleapis.com) | Enables services that service consumers want to use on Google Cloud Platform, lists the available or enabled services, or disables services that service consumers no longer use. |



Following table contains Google APIs which nedd to be enabled in GCP Project.
| API | Details |
| ----------- | ------------ |
| Cloud Composer API (composer.googleapis.com) | Manages Apache Airflow environments on Google Cloud Platform. |
| Secret Manager API (secretmanager.googleapis.com) | Stores sensitive data such as API keys, passwords, and certificates. Provides convenience while improving security. |
| Cloud Dataproc API (dataproc.googleapis.com) | Manages Hadoop-based clusters and jobs on Google Cloud Platform. |
| Cloud Source Repositories API (sourcerepo.googleapis.com) | Accesses source code repositories hosted by Google. |
| Cloud Resource Manager API (cloudresourcemanager.googleapis.com) | Creates, reads, and updates metadata for Google Cloud Platform resource containers. |
| Cloud Run Admin API (run.googleapis.com) | Deploy and manage user provided container images that scale automatically based on incoming requests. |
| Cloud Key Management Service (KMS) API (cloudkms.googleapis.com) | Manages keys and performs cryptographic operations in a central cloud service, for direct use by other cloud resources and applications. |
