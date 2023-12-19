#! /bin/bash
score=(curl -sSX POST --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan | grep score | awk '{print $2}' | sed 's/,$//')

eit_code=$?


if [[ "$score" < 6 ]];then
  echo "Your YAML file have some errors"
  $exit_code=12
  exit $exit_code
else
  echo "Your YAML files has the correct score: $score "
  exit 0
