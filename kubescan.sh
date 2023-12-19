#! /bin/bash
score=$(curl -sSX POST --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan | grep -i "score" | awk '{print $2}' | sed 's/,$//')


exit_code=$?


if [[ "$score" -lt 6 ]];then
  echo "Your YAML file have some errors"
  exit 1
else
  echo "Your YAML files has the correct score: $score "
  exit $exit_code
fi