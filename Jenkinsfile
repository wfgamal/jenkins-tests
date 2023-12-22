pipeline {
  agent any
  environment {
    
    imageNameK8s = "wfgamal/numeric-app"
    
    
  }
  tools {
        // Define tools here
        maven 'Maven-3.9.5' // Example Maven tool configuration  
        // kubectl 'kubectl'
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
        
      withKubeConfig(caCertificate: '-----BEGIN CERTIFICATE-----
MIIDBjCCAe6gAwIBAgIBATANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwptaW5p
a3ViZUNBMB4XDTIzMDYyMzE2MDYzN1oXDTMzMDYyMTE2MDYzN1owFTETMBEGA1UE
AxMKbWluaWt1YmVDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL+M
uK20P3kVpEPil2P21NMbgtqaOmgv1FAnB7n2dMwpD+cROTsd46SU77QUU/IAZ5Zs
CeRh71CpVmYzNT657HJqv0Cf12evMazFKV92eha5oE2z8V0d9Jf64NYC+tYMZkzh
FWEQs/a+ECjbkhMg/CNx0+cKAhnrj6jrYWX1KeEmJCYPImG9rR8lsVFmeQOxJVC2
eheR/EkCUHcWIQu5kSNywTfplgbc0dt0xWM1jCHDgmg4H4NfU2z9w03m4pZfUUR6
ZMsq9Cx6Abe3eMUlDzxRL0LB2VnBdYqCX81w4mtF8pwuw6Mc+QLR4i0AR0GCUgBu
eTewvUrMRTdgcoV8og8CAwEAAaNhMF8wDgYDVR0PAQH/BAQDAgKkMB0GA1UdJQQW
MBQGCCsGAQUFBwMCBggrBgEFBQcDATAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQW
BBRApE9t4N/4txOjwP9Ea340Ibz1UTANBgkqhkiG9w0BAQsFAAOCAQEAAKvjSq02
fr2AkHF4E9vjmVFcy9YGoXo9Cr8dBMwsTvt+mgwASV92ImvviSPb6ZQAK2+mryzz
4QRYexIRasBdgXUMmssmjze2D6NNkcpWhpfsc7Vmv32C+iJRG55RqgibdMAugB2W
XEc6MjKI/lt/k6m9dN7pgMmbx/jSnfKFrhiWxFJ808fDaWdf2+SROrUVCUqH7hqS
gLVL0lpmlcJcJFadfbomWD6Y/geBtIeRepDmaavxLF4FyjmQS3VDwvDjeVkF0BgS
muKsu9ahCU5pNVrxIHaC/P/R+qGuWUXv2cWiMLRa4HYPoHzk4mQgKbctNZDKobii
xokRzgLH3CltKw==
-----END CERTIFICATE-----', clusterName: 'minikube', contextName: 'minikube', credentialsId: 'kubeconfig-certs', namespace: 'default', restrictKubeConfigAccess: false, serverUrl: 'https://192.168.49.2:8443') {
          
            sh "sed -i \"s#replace#${imageNameK8s}#g\" k8s_deployment_service.yaml"
            sh 'curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.20.5/bin/linux/amd64/kubectl"'  
            sh 'chmod u+x ./kubectl'  
            sh './kubectl get pods'


        
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
