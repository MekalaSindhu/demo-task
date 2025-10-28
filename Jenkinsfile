pipeline {
    agent any

    environment {
        SONARQUBE = 'MySonarQube' // Jenkins SonarQube name
        AWS_REGION = 'us-east-1'
        DOCKER_IMAGE = 'react-app'
    }

    stages {

        // ===================================================
        // Stage 1: Checkout Code (GitHub)
        // ===================================================
        stage('Checkout Code') {
            steps {
                echo "🔹 Cloning repository..."
                git branch: 'main', url: 'https://github.com/MekalaSindhu/demo-task.git'
            }
        }

        // ===================================================
        // Stage 2: Terraform Init + Apply (Provision Infra)
        // ===================================================
        stage('Terraform Provisioning') {
            steps {
                dir('terraform') {
                    echo "🔹 Initializing Terraform..."
                    sh 'terraform init'

                    echo "🔹 Validating Terraform..."
                    sh 'terraform validate'

                    echo "🔹 Applying Terraform configuration..."
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        // ===================================================
        // Stage 3: SonarQube Code Analysis
        // ===================================================
        stage('SonarQube Code Analysis') {
            steps {
                echo "🔹 Running SonarQube analysis..."
                withSonarQubeEnv('MySonarQube') {
                    sh '''
                        npx sonar-scanner \
                        -Dsonar.projectKey=react-app \
                        -Dsonar.sources=src \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=<SONAR_TOKEN>
                    '''
                }
            }
        }

        // ===================================================
        // Stage 4: Build React App code
        // ===================================================
        stage('Build React App') {
            steps {
                echo "🔹 Building React application..."
                sh 'npm install'
                sh 'npm run build'
            }
        }

        // ===================================================
        // Stage 5: Docker Build & Deploy
        // ===================================================
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

