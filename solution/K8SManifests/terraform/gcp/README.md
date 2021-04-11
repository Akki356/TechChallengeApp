# TechChallengeApp setup on GCP

This directory contains code for deploying the application on a GCP GKE (K8S) cluster.

Step 1 Install google cloud SDK

On macos
brew install --cask google-cloud-sdk

For other operating systems please follow the instructions on the below link.
https://cloud.google.com/sdk/docs/install

Step 2 Initialize gcloud sdk
gcloud init

Create a new project

Step 4 

gcloud auth application-default login

Step 5 Add the project details in terraform.tfvars

The project name can be found using the following command 
gcloud config get-value project

terraform.tfvars should look similar to one below
project_id = "tech-challenge-app-project" #Change-me
region     = "us-central1" #Change-me

Step 6 Enable compute engine API and Kubernetes engine API
If you do not enable it now the next step will fail but terrafom will give you link to enable it.

Also enable billing to the project created.

Step 7 Initialize Terrafrom
terraform init

Step 8 Get the container credentials
First gcloud container clusters list to get the cluster details.

Next run gcloud container clusters get-credentials GKE_CLUSTER_ID --region REGION --project PROJECT_ID
eg: gcloud container clusters get-credentials tech-challenge-app-project-gke --region us-central1 --project tech-challenge-app-project
