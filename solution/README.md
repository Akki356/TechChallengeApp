# TechChallengeApp setup on GCP

This directory contains code for deploying the application on a GCP GKE (K8S) cluster.

Step 1: Install google cloud SDK

On macos
```brew install --cask google-cloud-sdk```

For other operating systems please follow the instructions on the below link.
https://cloud.google.com/sdk/docs/install

Step 2: Initialize gcloud sdk
```gcloud init```

Create a new project

Step 3: 

```gcloud auth application-default login```

Step 4: Add the project details in terraform.tfvars

The project name can be found using the following command 
```gcloud config get-value project```

terraform.tfvars should look similar to one below

```
project_id = "tech-challenge-app-project" #Change-me
region     = "us-central1" #Change-me
```

Step 5: Enable compute engine API and Kubernetes engine API
If you do not enable it now the next step will fail but terrafom will give you link to enable it.

Also enable billing to the project created.

Step 7 Initialize Terrafrom and apply
```
cd solution/terraform/gcp
terraform init
terraform apply
```
Step 8 Get the container credentials
First gcloud container clusters list to get the cluster details.

Next run ```gcloud container clusters get-credentials GKE_CLUSTER_ID --region REGION --project PROJECT_ID```
eg: gcloud container clusters get-credentials tech-challenge-app-project-gke --region us-central1 --project tech-challenge-app-project

Step 9:
```
cd ../kubernetes
terraform init
terraform apply
```
Step 10:
Enter password to set for the postgress user.

Step 11: 
Wait for terraform to successfully complete
Terraform will create a service for the frontend and expose it using external ip using loadbalancer.
Till the ip becomes accessable you can check the frontend by using ```kubctl port-forward pod-name 3000:3000```
eg:kubctl port-forward techchallengeapp-deployment-bf677df7f-4d8b5

Step 12:
Access the the frontend using browser on url localhost:3000
