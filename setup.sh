#!/bin/sh
set -e

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

export PROJECT_ID=dot-$(date +%Y%m%d%H%M%S)
echo "export PROJECT_ID=$PROJECT_ID" >> .env
gcloud projects create $PROJECT_ID

echo "
Please open https://console.cloud.google.com/marketplace/product/google/container.googleapis.com?project=${PROJECT_ID} in a browser and *ENABLE* the API."
gum input --placeholder "
Press the enter key to continue."

export KUBECONFIG=$PWD/kubeconfig.yaml
echo "export KUBECONFIG=$KUBECONFIG" >> .env

gcloud container clusters create dot --project ${PROJECT_ID} --region us-east1 --machine-type e2-standard-2 --num-nodes 1 --enable-network-policy

gum style \
	--foreground 212 --border-foreground 212 --border double \
	--margin "1 2" --padding "2 4" \
	'The setup is almost finished.' \
    '
Execute "source .env" to set the environment variables.'
