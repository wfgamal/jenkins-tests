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


    // stage('Build Artifact - Maven') {
    //   steps {
    //     script {
    //                 def mvnHome = tool name: 'Maven-3.9.5', type: 'Tool'
    //                 sh "${mvnHome}/bin/mvn clean package"
    //             }
    //   }
    // }
  

stage('Build Artifact - Maven') {
      steps {
        script {
                    
                    sh "mvn clean package"
                    archive 'target/*.jar'
                }
      }
    }

stage('Unit test- Maven') {
      steps {
                    
        sh "mvn test"
                }
            } 

stage('SonarQube - SAST') {
      steps {
                    
        withSonarQubeEnv('sonarqube') {
      sh "mvn clean verify sonar:sonar -Dsonar.projectKey=devsecops -Dsonar.projectName='devsecops'"
    }
                }
            } 

stage("SonarQube - Quality Gate") {
            steps {
              timeout(time: 1, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
              }
            }
          }

stage("Trivy - Base Image scan") {
  
            steps {
              sh " bash trivyscan.sh"
              }
            }
          
stage("OPA Conftest -Dockerfile") {
  
            steps {
              sh "docker run --rm -v \$(pwd):/project openpolicyagent/conftest test --policy dockerfile-opa-scan.rego Dockerfile"
              }
            }

// stage(" Docker Build & Push") {
          
//               steps {
//         withDockerRegistry([credentialsId: "dockerhub-token", url: ""]) {
//           sh 'printenv'
//           sh 'sudo docker build -t wfgamal/numeric-app:"$BUILD_NUMBERIT" .'
//           sh 'docker push wfgamal/numeric-app:"BUILD_NUMBER"'
//         }
//       }
//             }            

  }

post {
      always {
            junit '**/target/surefire-reports/*.xml'
            // Publish JaCoCo code coverage report
            jacoco(execPattern: '**/target/jacoco.exec')
        }
    }    
}