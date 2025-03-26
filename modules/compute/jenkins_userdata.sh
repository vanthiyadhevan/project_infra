#!/bin/bash

# Install jenkins on ubuntu server

# Update the Repodsitory
sudo apt-get update -y

# install javajdk-17 for run the jenkins application
sudo apt install openjdk-17-jdk -y

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