#!/bin/bash

# Install jenkins on ubuntu server

# Update the Repodsitory
sudo apt-get update -y

# install javajdk-17 for run the jenkins application
sudo apt install openjdk-21-jdk -y

# install maven and unzip
sudo apt install maven unzip -y

# set jenkins key 
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# update the reposirory and install jenkins
sudo apt-get update
sudo apt-get install jenkins -y

# ---------------------------------------
# AWS CLI installation on ubuntu server
# ---------------------------------------
sudo apt install -y unzip curl

# Fetch the latest version of AWS CLI v2 from AWS
LATEST_VERSION_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

# Download AWS CLI v2
curl "$LATEST_VERSION_URL" -o "awscliv2.zip"

# Unzip the downloaded file
unzip awscliv2.zip

# Run the installation script
sudo ./aws/install

# Verify the installation
aws --version > /dev/null

# Cleanup the downloaded files
rm -rf awscliv2.zip aws

# --------------------------------------
# Docker installation on ubuntu server
# --------------------------------------
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo usermod -aG docker ubuntu

sudo chmod 777 /var/run/docker.sock

sudo newgrp docker

sudo usermode -aG docker jenkins

# --------------------------------------
# Trivy installation on ubuntu server
# --------------------------------------
sudo apt-get install wget apt-transport-https gnupg lsb-release -y 

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list

sudo apt-get update

sudo apt-get install trivy -y

# --------------------------------------
# Install Helm on ubuntu server
# --------------------------------------

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm -y
# --------------------------------------

