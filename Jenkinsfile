pipeline {
    agent any

    environment {
        SONARQUBE = 'MySonarQube'
        AWS_REGION = 'us-east-1'
        DOCKER_IMAGE = 'react-app'
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "🔹 Cloning repository..."
                git branch: 'main', url: 'https://github.com/MekalaSindhu/demo-task.git'
            }
        }

        stage('Terraform Provisioning') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-credentials', // ✅ Matches your Jenkins ID
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    dir('terraform') {
                        echo "🔹 Checking AWS credentials..."
                        sh '''
                            echo "AWS_ACCESS_KEY_ID is set: ${AWS_ACCESS_KEY_ID:+YES}"
                            echo "AWS_SECRET_ACCESS_KEY is set: ${AWS_SECRET_ACCESS_KEY:+YES}"
                        '''

                        echo "🔹 Initializing Terraform..."
                        sh 'terraform init'

                        echo "🔹 Validating Terraform..."
                        sh 'terraform validate'

                        echo "🔹 Applying Terraform configuration..."
                        sh '''
                            export AWS_DEFAULT_REGION="${AWS_REGION}"
                            terraform apply -auto-approve
                        '''
                    }
                }
            }
        }

        stage('SonarQube Code Analysis') {
            steps {
                echo "🔹 Running SonarQube analysis..."
                withSonarQubeEnv('MySonarQube') {
                    withCredentials([string(credentialsId: 'Sonarqube', variable: 'SONAR_TOKEN')]) { // ✅ updated ID
                        sh '''
                            npx sonar-scanner \
                            -Dsonar.projectKey=react-app \
                            -Dsonar.sources=src \
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Build React App') {
            steps {
                echo "🔹 Building React application..."
                sh 'npm install'
                sh 'npm run build'
            }
        }

        stage('Docker Build and Deploy') {
            steps {
                echo "🔹 Building and Deploying Docker container..."
                sh '''
                    docker stop react-app || true
                    docker rm react-app || true
                    docker build -t react-app .
                    docker run -d -p 80:80 --name react-app react-app
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful! React app running on port 80."
        }
        failure {
            echo "❌ Build failed! Check Jenkins logs for details."
        }
    }
}
