pipeline {
  agent any
  environment {
    
    imageNameK8s = "wfgamal/numeric-app"
    
    
  }
  tools {
        // Define tools here
        maven 'Maven-3.9.5' // Example Maven tool configuration  
        kubectl 'kubectl 1.28.4'
    }
stages {



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

// stage("Vulnerability Scan - Docker"){
  
//     parallel{
//       stage("Trivy - Base Image scan") {
  
//             steps {
//               sh " bash trivyscan.sh"
//               }
//             }
//       stage("OPA Conftest -Dockerfile") {
  
//             steps {
//               sh "docker run --rm -v \$(pwd):/project openpolicyagent/conftest test --policy dockerfile-opa-scan.rego Dockerfile"
//               }
//             }

//     }
  
// }


stage(" Docker Build & Push") {
          
      steps {
        withDockerRegistry(credentialsId: 'dockerhub-cred', url: '') {
          sh 'printenv'
          sh 'docker build -t $imageNameK8s:"$BUILD_NUMBER" .'
          sh 'docker push $imageNameK8s:"$BUILD_NUMBER"'
        }
      }
            }   

                 
// stage("Kubesec - k8s scans") {
  
//       steps {
//               sh 'bash kubescan.sh'
//               }
//             }    

stage("Deploy to k8s") {
  
      steps {
        
      withKubeConfig(caCertificate: '', clusterName: 'minikube', contextName: 'minikube', credentialsId: 'kubeconfig', namespace: 'default', restrictKubeConfigAccess: false, serverUrl: 'https://192.168.49.2:8443') {
          sh """
            sed -i 's#replace#${imageNameK8s}:${BUILD_NUMBER}#g' k8s_deployment_service.yaml
            kubectl apply -f k8s_deployment_service.yaml

          """

        
}
          
              
              }
            }                     


  }                             


}  

post {
      always {
            junit '**/target/surefire-reports/*.xml'
            // Publish JaCoCo code coverage report
            jacoco(execPattern: '**/target/jacoco.exec')
        }
}    
