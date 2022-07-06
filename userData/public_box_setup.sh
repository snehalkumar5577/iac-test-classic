#!/usr/bin/env bash
set -e
set -x
echo "Setup for public box started....."

echo "Installing docker....."

sudo yum update -y
sudo yum -y install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chmod 666 /var/run/docker.sock
#docker version
echo "docker installation completed"

echo "jenkins installation started.."
docker run --name jenkins -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock snehalkumar/jenkins-with-plugins:latest
echo "jenkins installation completed"

echo "ansible installation started..."
sudo amazon-linux-extras install ansible2 -y
ansible --version
echo "ansible installation completed"