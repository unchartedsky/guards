#!/bin/bash -xe

# Create the Terraform Admin Project
gcloud projects create ${TF_ADMIN} \
--organization ${TF_VAR_org_id} \
--set-as-default

gcloud beta billing projects link ${TF_ADMIN} \
--billing-account ${TF_VAR_billing_account}

# Create the Terraform service account
gcloud iam service-accounts create terraform \
--display-name "Terraform admin account"

gcloud iam service-accounts keys create ${TF_CREDS} \
--iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding ${TF_ADMIN} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
 --role roles/viewer

gcloud projects add-iam-policy-binding ${TF_ADMIN} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
 --role roles/storage.admin

gcloud services enable cloudresourcemanager.googleapis.com && \
gcloud services enable cloudbilling.googleapis.com && \
gcloud services enable iam.googleapis.com && \
gcloud services enable compute.googleapis.com && \
gcloud services enable sqladmin.googleapis.com && \
gcloud services enable container.googleapis.com

# Add organization/folder-level permissions
gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role roles/resourcemanager.projectCreator

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role roles/billing.user
