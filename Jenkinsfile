pipeline {
  gent {
    docker {
      image 'abhishekf5/maven-abhishek-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // mount Docker socket to access the host's Docker daemon
    }
  // environment {
  //   deploymentName = "devsecops"
  //   containerName = "devsecops-container"
  //   serviceName = "devsecops-svc"
  //   imageName = "siddharth67/numeric-app:${GIT_COMMIT}"
  //   applicationURL="http://devsecops-demo.eastus.cloudapp.azure.com"
  //   applicationURI="/increment/99"
  // }

  stages {

    stage('Build Artifact - Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archive 'target/*.jar'
      }
    }
  }
}