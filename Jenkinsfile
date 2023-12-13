pipeline {
  agent any
  // environment {
  //   deploymentName = "devsecops"
  //   containerName = "devsecops-container"
  //   serviceName = "devsecops-svc"
  //   imageName = "siddharth67/numeric-app:${GIT_COMMIT}"
  //   applicationURL="http://devsecops-demo.eastus.cloudapp.azure.com"
  //   applicationURI="/increment/99"
  // }

  stages {


    stage('Workspace Cleanup') {
            steps {
                cleanWs()
            }
        }

    stage('Build Artifact - Maven') {
      steps {
        tool name: 'Maven', type: 'Tool'
        sh 'mvn clean package'
      }
    }
  }
}