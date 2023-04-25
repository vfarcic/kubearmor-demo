#!/bin/sh

source .env

gcloud projects delete $PROJECT_ID
