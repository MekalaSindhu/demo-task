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
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key-id', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('terraform') {
                        echo "🔹 Checking AWS credentials..."
                        bat '''
                            echo AWS_ACCESS_KEY_ID is set
                            echo AWS_SECRET_ACCESS_KEY is set
                        '''

                        echo "🔹 Initializing Terraform..."
                        bat 'terraform init'

                        echo "🔹 Validating Terraform..."
                        bat 'terraform validate'

                        echo "🔹 Planning Terraform configuration..."
                        bat '''
                            set AWS_DEFAULT_REGION=%AWS_REGION%
                            terraform plan -out=tfplan
                        '''

                        echo "🔹 Applying Terraform configuration..."
                        bat '''
                            set AWS_DEFAULT_REGION=%AWS_REGION%
                            terraform apply -auto-approve tfplan
                        '''
                        
                        echo "🔹 Capturing Terraform outputs..."
                        bat '''
                            terraform output -json > terraform_output.json
                            type terraform_output.json
                        '''
                    }
                }
            }
        }

        stage('Wait for EC2 Instance') {
            steps {
                echo "🔹 Waiting for EC2 instance to be ready..."
                sleep(time: 120, unit: 'SECONDS')
            }
        }

        stage('SonarQube Code Analysis') {
            steps {
                echo "🔹 Running SonarQube analysis..."
                withSonarQubeEnv('MySonarQube') {
                    withCredentials([string(credentialsId: 'Sonarqube', variable: 'SONAR_TOKEN')]) {
                        bat '''
                            npx sonar-scanner ^
                            -Dsonar.projectKey=react-app ^
                            -Dsonar.sources=src ^
                            -Dsonar.host.url=http://localhost:9000 ^
                            -Dsonar.login=%SONAR_TOKEN%
                        '''
                    }
                }
            }
        }

        stage('Build React App') {
            steps {
                echo "🔹 Building React application..."
                bat 'npm install'
                bat 'npm run build'
            }
        }

        stage('Docker Build and Deploy') {
            steps {
                echo "🔹 Building and Deploying Docker container..."
                bat '''
                    docker stop react-app 2>nul || echo Container not running
                    docker rm react-app 2>nul || echo Container not found
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
