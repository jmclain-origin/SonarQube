# SonarQube Cloud Setup

AWS EC2 instance configuration

Select Ubuntu image for installation

Minimum Requirements

- 4gb RAM
- 16gb Storage space
- x2 CPU's

<sub>_~ I think it runs best on t3.medium, but it should be able to run on a t3.micro_</sub>

---

## EC2 Setup Steps

1. [Update OS](#update-ubuntu)
1. [install packages](#install-packages)
   1. [ ] Nginx
   2. [ ] Docker
   3. [ ] Vim
   4. [ ] Java 11
1. Configure system dependencies
   1. [Java](#system-config)
   2. [ElasticSearch](#elasticsearch)
   3. [Nginx](#nginx)
   4. Docker

---

### Update Ubuntu

Shell command:

```bash
sudo apt update && sudo apt upgrade -y
```

---

### Install packages

Shell command:

```bash
sudo apt install openjdk-11-jdk nginx vim
```

---

### System config

#### Java

Add installation to environment variables

Shell command:

```bash
sudo vim /etc/environment
```

**Content:**

```conf
# FILE: /etc/environment #

$JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

Shell command:

```bash
source /etc/environment
```

#### Elasticsearch

Set memory limit <sub>\* linux only</sub>

_Shell command:_

```bash
sudo sysctl -w vm.max_map_count=262144
```

---

## Nginx

Shell command:

```bash
sudo vim /etc/nginx/sites-enabled/default
```

Add to file content inside `server` scope

```conf
server {
    location / {
        proxy_pass http://localhost:9000/;
        proxy_buffering off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port $server_port;
    }
}
```

Restart Nginx service

```bash
sudo systemctl restart nginx
```

## Docker

Install Docker

Shell command:

```bash
sudo snap install docker
```

Create source directory and Compose file for Docker

Shell command:

```bash
mkdir ~/sonarqube && vim ~/sonarqube/compose.yml
```

File content:

```yaml
version: '3'

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
      - '9000:9000'
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
```

Start Docker containers

Shell command:

```bash
sudo docker compose up -d
```

_*Checking logs*_

```bash
sudo docker compose logs sonarqube_sonarqube_1
```

_*Checking Docker status*_

```bash
sudo docker stats
```

---

Visit public URL for EC2 instance

example: *http://ec2-11-222-33-44.us-east-2.compute.amazonaws.com*

### default credentials

username: `admin`  
 password: `admin`

> :warning: make sure to visit **http**  
> https traffic require SSL certificate to be setup

---
