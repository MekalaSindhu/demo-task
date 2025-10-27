#!/bin/bash
set -e

# ====== System Update ======
yum update -y

# ====== Install Docker ======
yum install -y docker git
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user

# ====== Install Java (for Jenkins) ======
amazon-linux-extras install java-openjdk11 -y

# ====== Install Jenkins ======
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y jenkins
systemctl enable jenkins
systemctl start jenkins

# ====== Install Node.js (for React builds) ======
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# ====== Run SonarQube using Docker ======
docker run -d --name sonarqube -p 9000:9000 sonarqube:lts

# ====== Optional: Pre-pull Jenkins Agent Image ======
docker pull jenkins/jenkins:lts

echo "Setup Complete: Jenkins -> :8080 | SonarQube -> :9000"

