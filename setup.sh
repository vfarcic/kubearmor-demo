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

gcloud container get-server-config --region us-east1

export K8S_VERSION=$(gum input --placeholder "Type a valid master version from the previous output.")

gum spin --spinner line --title "Waiting for the container API to be enabled..." -- sleep 60

export KUBECONFIG=$PWD/kubeconfig.yaml
echo "export KUBECONFIG=$KUBECONFIG" >> .env

gcloud container clusters create dot --project ${PROJECT_ID} --region us-east1 --machine-type n1-standard-2 --num-nodes 1 --cluster-version ${K8S_VERSION} --node-version ${K8S_VERSION}

gum style \
	--foreground 212 --border-foreground 212 --border double \
	--margin "1 2" --padding "2 4" \
	'The setup is almost finished.' \
    '
Execute "source .env" to set the environment variables.'
