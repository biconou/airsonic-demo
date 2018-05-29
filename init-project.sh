#!/usr/bin/env bash

oc new-project airsonic \
    --display-name='Airsonic' \
    --description='This project aims to depoy an Airsonic application on OpenShift'

oc new-app --template=postgresql-persistent \
    --param=DATABASE_SERVICE_NAME=postgresql \
    --param=POSTGRESQL_DATABASE=airsonic \
    --param=MEMORY_LIMIT=128Mi \
    --param=VOLUME_CAPACITY=1Gi \
    --param=POSTGRESQL_VERSION=9.5


oc create imagestream airsonic-webapp

cd oc

oc create -f pvc_nas_data.json

oc create -f airsonic-webapp-build.json
oc start-build airsonic-webapp-build

oc apply -f airsonic-webapp-deployment.json
oc apply -f airsonic-webapp-service.json
oc apply -f airsonic-webapp-route.json

