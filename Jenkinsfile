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
  tools {
        // Define tools here
        maven 'Maven-3.9.5' // Example Maven tool configuration
        
    }
  stages {


    stage('Build Artifact - Maven') {
      steps {
        script {
                    def mvnHome = tool name: 'Maven-3.9.5', type: 'Tool'
                    sh "${mvnHome}/bin/mvn clean package"
                }
      }
    }
  }
}