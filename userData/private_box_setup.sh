#!/usr/bin/env bash
set -e
set -x
echo "Setup for private box started....."

echo "Installing docker....."

sudo yum update -y
sudo yum -y install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chmod 666 /var/run/docker.sock
docker version

echo "docker installation completed"
