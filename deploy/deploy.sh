#!/bin/bash

export $(egrep -v '^#' .env)

printenv

sed -i.bak \
    -e "s|SQL_USER_VALUE|${SQL_USER}|g" \
    -e "s|SQL_PASSWORD_VALUE|${SQL_PASSWORD}|g" \
    -e "s|SECRET_KEY_VALUE|${SECRET_KEY}|g" \
    secret.yaml
rm secret.yaml.bak

sed -i.bak \
    -e "s/DOCKER_VERSION_VALUE/${BUILD_VERSION}/g" \
    -e "s/DEBUG_VALUE/${DEBUG}/g" \
    -e "s/DJANGO_ALLOWED_HOSTS_VALUE/${DJANGO_ALLOWED_HOSTS}/g" \
    -e "s/SQL_ENGINE_VALUE/${SQL_ENGINE}/g" \
    -e "s/SQL_DATABASE_VALUE/${SQL_DATABASE}/g" \
    -e "s/SQL_HOST_VALUE/${SQL_HOST}/g" \
    -e "s/SQL_PORT_VALUE/${SQL_PORT}/g" \
    -e "s/DATABASE_VALUE/${DATABASE}/g" \
    -e "s/DJANGO_SETTINGS_MODULE_VALUE/${DJANGO_SETTINGS_MODULE}/g" \
    deployment.yaml
rm deployment.yaml.bak

sed -i.bak \
    -e "s/CHP_HOSTNAME_VALUE/${CHP_HOSTNAME}/g" \
    -e "s/CHP_ALB_TAG_VALUE/${CHP_ALB_TAG}/g" \
    -e "s/CHP_ALB_SG_VALUE/${CHP_ALB_SG}/g" \
    -e "s/ENVIRONMENT_TAG_VALUE/${ENVIRONMENT_TAG}/g" \
    ingress.yaml
rm ingress.yaml.bak

kubectl apply -f namespace.yaml
kubectl apply -f secret.yaml
kubectl apply -f deployment.yaml
kubectl apply -f services.yaml
kubectl apply -f ingress.yaml
