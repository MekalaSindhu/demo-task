pipeline {
  agent any
  tools {nodejs "node"}
  stages {

    stage('Install Dependencies') {
      steps {
        sh 'npm install'
      }
    }
    stage('Production Build') {
      steps {
		    sh 'npm run build'
      }
    }
    stage('Copy Build files to Web Server Location') {
      steps {
		    sh 'cp -r ./build/* /var/www/html/webserver/'
      }
    }
  post { 
        always { 
            cleanWs()
        }
    }
  }
}