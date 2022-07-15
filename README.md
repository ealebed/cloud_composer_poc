# GCP Cloud Composer PoC

Example how to deploy GCP Cloud Composer from terraform code and run Airflow DAG that creates a Cloud Dataproc cluster, runs the Hadoop
wordcount example, and deletes the Dataproc cluster.

TODO: investigate and compare current implementation with [Run Dataproc Serverless workloads with Cloud Composer](https://cloud.google.com/composer/docs/composer-2/run-dataproc-workloads)

More info:
- [Create environments with Terraform](https://cloud.google.com/composer/docs/composer-2/terraform-create-environments)
- [Running a Hadoop wordcount job on a Dataproc cluster](https://cloud.google.com/composer/docs/tutorials/hadoop-wordcount-job#airflow-2_1)
- [Test, synchronize, and deploy your DAGs using version control](https://cloud.google.com/composer/docs/dag-cicd-integration-guide)
