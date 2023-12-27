# SonarQube Cloud Setup

AWS EC2 instance configuration

Select Ubuntu image for installation

Minimum Requirements

- 4gb RAM
- 16gb Storage space
- x2 CPU's


---

## EC2 Setup Steps

1. Update & Install Dependencies
    1. Java 11
    2. Nginx
    3. Docker
    4. Vim
2. Configure system dependencies
    1. Java
    2. ElasticSearch
    3. Nginx
    4. Docker

---

### Update Ubuntu

Shell command:

```bash
sudo apt update && sudo apt upgrade -y
```

---

### Install dependencies

Shell command:

```bash
sudo apt install openjdk-11-jdk nginx vim
```

---

### Configure Java & Elasticsearch

#### Java

Add installation to environment variables

Shell command:

```bash
$>sudo vim /etc/environment
```

__Content:__

```conf
# FILE: /etc/environment #

$JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

Shell command:

```bash
$>source /etc/environment
```

#### Elasticsearch

Set memory limit <sub>* linux only</sub>

_Shell command:_

```bash
$>sudo sysctl -w vm.max_map_count=262144
```

---

## Docker Setup

Install Docker

Shell command:

```bash
$>sudo snap install docker
```

Create source directory and Compose file for Docker

Shell command:

```bash
$>vim ~/sonarqube/compose.yml
```

File content:

```yaml
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
```

Start Docker containers

Shell command:

```bash
$>sudo docker compose up -d
```

_*Checking logs*_

```bash
$>sudo docker compose logs sonarqube_sonarqube_1
```

*_Checking Docker status_*

```bash
$>sudo docker stats
```

---

## Reverse Proxy setup with Nginx

Shell command:

```bash
$>sudo vim /etc/nginx/sites-enabled/default
```

Add content inside `server` scope

```conf
server {
    # present content

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
$>sudo systemctl restart nginx
```

---

Visit public URL for EC2 instance

example: *http://ec2-11-222-33-44.us-east-2.compute.amazonaws.com*

### default credentials

username: `admin`  
  password: `admin`

> :warning: make sure to visit __http__  
https traffic require SSL certificate to be setup

---



[Get started with Bitbucket Pipelines](https://support.atlassian.com/bitbucket-cloud/docs/get-started-with-bitbucket-pipelines/)

[SonarQube Bitbucket Intergration](https://docs.sonarsource.com/sonarqube/latest/devops-platform-integration/bitbucket-integration/bitbucket-cloud-integration/)

Create [Bitbucket OAuth consumer](https://support.atlassian.com/bitbucket-cloud/docs/use-oauth-on-bitbucket-cloud/)

Collect [Bitbucket Username](https://bitbucket.org/account/settings/)

Create [App Password](https://bitbucket.org/account/settings/app-passwords/)

Input gather data as prompted in SonarQube dashbroad

> 💡 If successful you should see list of current repositories hosted on [Bitbucket](https://bitbucket.org)

## Analyzing Code with Pipelines

Add environment variables to repository  
  Generate in SonarQube dashbroad

- SONAR_TOKEN
- SONAR_HOST_URL

Add config file to root directory of repository  
  `bitbucket-pipeline.yml`

```yaml
# Sample format of YAML file
# source: https://docs.sonarsource.com/sonarqube/latest/devops-platform-integration/bitbucket-integration/bitbucket-cloud-integration/
image: <image for build>

definitions:
  steps: &build-step
    - step:
        name: SonarQube analysis
        image: sonarsource/sonar-scanner-cli:latest
        caches:
          - sonar
        script:
          - sonar-scanner
  caches:
    sonar: /opt/sonar-scanner/.sonar

clone:
  depth: full

pipelines:
  branches:
    '{master,main,develop}':
      - step: *build-step

  pull-requests:
    '**':
      - step: *build-step

```

> :warning: YAML configuration will vary based upon codebase for analysis
