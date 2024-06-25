pipeline {
  agent any
  environment {
	registryName = "materialdashdemo"
	registryUrl = "materialdashdemo.azurecr.io"
	registryCredential = "ACR"
	dockerImage = ''
  }
  tools {nodejs "node"}
  post { 
        always { 
            cleanWs()
        }
    }
 
  stages {
    stage('Production Build') {
      steps {
        sh 'npm install'
		    sh 'npm run build'
      }
    }
//Sonarqube
    stage('SonarQube analysis') {
      steps {
        script {
          def scannerHome = tool 'sonarqubescanner';
          withSonarQubeEnv('sonarqubeserver') {
            sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=mdreactapp -Dsonar.projectName=mdreactapp"
          }
        }
      }
    }
//Create docker image
	  stage('Create Docker Image') {
	    steps {
		    script {
//Build docker image
		  	  dockerImage = docker.build registryName

		    }
	    }
	  }
// Uploading Docker images into ACR
    stage('Upload Image to ACR') {
      steps{   
        script {
          docker.withRegistry( "http://${registryUrl}", registryCredential ) {
          dockerImage.push("${env.BUILD_NUMBER}")
          }
        }
      }
    }
//Deploy ACR image to AKS
    stage ('AKS Deploy') {
      steps {
        script {
          withKubeConfig([credentialsId: 'K8S', serverUrl: '']) {
          sh ('kubectl apply -f deployment.yaml')
          // sh 'kubectl set image materialdashdemo.azurecr.io/materialdashdemo=${BUILD_NUMBER}
              }
          }
        }
     }
  }
}