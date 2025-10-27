output "ec2_public_ip" {
  value = aws_instance.react_server.public_ip
}

output "jenkins_url" {
  value = "http://${aws_instance.react_server.public_ip}:8080"
}

output "sonarqube_url" {
  value = "http://${aws_instance.react_server.public_ip}:9000"
}


