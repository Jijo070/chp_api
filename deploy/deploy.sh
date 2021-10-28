#!/bin/bash

# variables 
projectName="chp-api"
namespace="chp"
# replace place_holder with values from env var
# env var's key needs to be the same as the place_holder
toReplace=('BUILD_VERSION')

# export .env values to env vars
export $(egrep -v '^#' env)

printenv

# replace variables in values.yaml with env vars

for item in "${toReplace[@]}";
do
  sed -i.bak \
      -e "s/${item}/${!item}/g" \
      values.yaml
  rm values.yaml.bak
done

# helm delete
helm -n ${namespace} delete ${projectName}


sed -i.bak \
    -e "s/DJANGO_ALLOWED_HOSTS_VALUE/${DJANGO_ALLOWED_HOSTS}/g" \
    templates/deployment.yaml
rm templates/deployment.yaml.bak

echo $DJANGO_ALLOWED_HOSTS

# deploy helm chart
helm -n ${namespace} install --set debug=:$DEBUG,secret_key=$SECRET_KEY,sql_engine=$SQL_ENGINE,sql_database=$SQL_DATABASE,sql_user=$SQL_USER,sql_password=$SQL_PASSWORD,sql_host=$SQL_HOST,sql_port=:$SQL_PORT,database=$DATABASE,django_settings_module=$DJANGO_SETTINGS_MODULE ${projectName} ./