#!/bin/bash

# Exit on any error
set -e

# Update package index
echo "Updating package index..."
sudo apt update

# Install OpenJDK 17, zip, and unzip
echo "Installing OpenJDK 17, zip, and unzip..."
sudo apt install -y openjdk-17-jdk zip unzip

# Set up the JAVA_HOME environment variable
echo "Setting JAVA_HOME environment variable..."
echo "export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))" | sudo tee /etc/profile.d/jdk.sh
source /etc/profile.d/jdk.sh

# Installing Postgres
echo "Adding PostgreSQL repository..."
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

echo "Installing PostgreSQL..."
sudo apt install postgresql postgresql-contrib -y

# Initiate the database server to begin operations
echo "Starting PostgreSQL service..."
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Create database and its owner
echo "Creating SonarQube database and user..."
sudo -u postgres psql -c "CREATE DATABASE sonarqubedb;"
sudo -u postgres psql -c "CREATE USER sonar WITH ENCRYPTED PASSWORD 'sonar';"
sudo -u postgres psql -c "GRANT ALL ON SCHEMA public TO sonar;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqubedb TO sonar;"
sudo -u postgres psql -c "ALTER DATABASE sonarqubedb OWNER TO sonar;"

# Download SonarQube server - community version
echo "Downloading SonarQube server..."
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.6.92038.zip

# Unzip content
echo "Unzipping SonarQube..."
unzip sonarqube-*.zip
sudo mv sonarqube-9.9.6.92038 sonarqube
sudo mv sonarqube /opt/

# Create sonarqube user and its group
echo "Creating SonarQube user and group..."
sudo groupadd sonarqube
sudo useradd -d /opt/sonarqube -g sonarqube sonarqube
sudo chown -R sonarqube:sonarqube /opt/sonarqube

# Insert user runner after `APP_NAME="SonarQube"` line
echo "Configuring SonarQube to run as user 'sonarqube'..."
sudo sed -i 's/APP_NAME="SonarQube"/APP_NAME="SonarQube"\n\nRUN_AS_USER=sonarqube/' /opt/sonarqube/bin/linux-x86-64/sonar.sh

# Create SonarQube launcher service
echo "Creating SonarQube service..."
sudo tee /etc/systemd/system/sonarqube.service <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target
[Service]
Type=forking
User=sonarqube
Group=sonarqube
PermissionsStartOnly=true
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
StandardOutput=journal
LimitNOFILE=131072
LimitNPROC=8192
TimeoutStartSec=5
Restart=always
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

# Configuring the database
echo "Configuring SonarQube database..."
sudo tee /opt/sonarqube/conf/sonar.properties <<EOF
sonar.web.port=9000
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqubedb
EOF

# Start SonarQube Server
echo "Starting SonarQube service..."
sudo systemctl enable sonarqube.service
sudo systemctl start sonarqube.service

echo "SonarQube installation and configuration completed successfully!"