#!/bin/bash

# Function to update Ubuntu
update_ubuntu() {
  echo "Updating Ubuntu..."
  sudo apt update && sudo apt upgrade -y
  echo "Ubuntu update complete."
}

# Function to install packages
install_packages() {
  echo "Installing packages..."
  sudo apt install openjdk-11-jdk nginx vim -y
  echo "Packages installed."
}

# Function to configure Java environment variables
configure_java() {
  echo "Configuring Java..."
  sudo bash -c 'echo "JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/environment'
  source /etc/environment
  echo "Java configuration complete."
}

# Function to set Elasticsearch memory limit (Linux only)
configure_elasticsearch() {
  echo "Configuring Elasticsearch..."
  sudo sysctl -w vm.max_map_count=262144
  echo "Elasticsearch configuration complete."
}

# Function to configure Nginx
configure_nginx() {
  echo "Configuring Nginx..."
  sudo bash -c 'cat <<EOF > /etc/nginx/sites-enabled/default
server {
    location / {
        proxy_pass http://localhost:9000/;
        proxy_buffering off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port $server_port;
    }
}
EOF'
  sudo systemctl restart nginx
  echo "Nginx configuration complete."
}

# Function to install Docker and start containers
install_docker() {
  echo "Installing Docker..."
  sudo snap install docker
  echo "Creating Docker Compose file..."
  cat <<EOF > ~/sonarqube/compose.yml
version: "3"

services:
  sonarqube:
    image: sonarqube:developer
    depends_on:
      - db
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonar
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_logs:/opt/sonarqube/logs
    ports:
      - "9000:9000"
  db:
    image: postgres:12
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonar
    volumes:
      - postgresql:/var/lib/postgresql
      - postgresql_data:/var/lib/postgresql/data

volumes:
  sonarqube_data:
  sonarqube_extensions:
  sonarqube_logs:
  postgresql:
  postgresql_data:
EOF
  echo "Starting Docker containers..."
  sudo docker-compose -f ~/sonarqube/compose.yml up -d
  echo "Docker installation and configuration complete."
}

# Main script
update_ubuntu
install_packages
configure_java
configure_elasticsearch
configure_nginx
install_docker

echo "All setup steps completed successfully."
