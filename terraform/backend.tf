terraform {
  backend "gcs" {
    bucket = "" # GCS bucket name for storing terraform state
    credentials = "../credentials.json"
  }
}
