#! /bin/bash
imageName=$(awk 'NR==1 {print $2}' Dockerfile)


docker run -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.38.3 --exit-code 0 --severity HIGH,MEDIUM image ${imageName}
docker run -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.38.3 --exit-code 1 --severity CRITICAL image ${imageName}


exit_code = $?

echo "Exit Code: ${exit_code}"

if [[ ${exit_code} -eq 1 ]]; then
   echo " Critical vulnerabilities found in your image ${imageName} "
   exit 1
else
   echo "Image ${imageName} has no vulnerabilities"   

 fi  