# SonarQube

Table of Contents:

1. [Overview](#overview)
2. [Installation](#installation)

    <details>
    <summary>
    more information

    </summary>

      1. [Docker](#docker)
      2. [Docker Compose](#docker-compose)
      3. [Zip File](#zip-file)
      4. [Homebrew](#homebrew) <sup>*</sup>

    </details>

3. [Configs, Settings & Setup](#configuration-settings-and-setup)

<sub>* - MacOS only</sub>

---

## Overview

Lorem ipsum dolor sit am eiusmod tempor incididunt ut lab ord
Lorem ipsum dolor sit am eiusmod tempor incididunt ut lab ord
Lorem ipsum dolor sit am eiusmod tempor incididunt ut lab ord
Lorem ipsum dolor sit am eiusmod tempor incididunt ut lab ord
Lorem ipsum dolor sit am eiusmod tempor incididunt ut lab ord
Lorem ipsum dolor sit am eiusmod tempor incididunt ut lab ord

---

<!-- End of Configuration section -->

---

<!-- ## Local analiys configuration -->

---

## Installation

<!-- Prerequites

- SonarQube
  - Java >=11 (JDK - JRE)

- Database
  - *Only one needed*
    - PostgreSQL
    - MicrosoftSQL server
    - JDBC -->

### Database

Several external database engines are supported. Be sure to follow the requirements listed for your database. They are real requirements not recommendations.

Create an empty schema and a sonarqube user. Grant this sonarqube user permissions to create, update, and delete objects for this schema.

<sub>

*see [online docs](https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/install-the-server/installing-the-database/) for furthur information*

</sub>

---

<details>

<summary>
Using Docker to create database
<sub>- (PostgreSQL only in examples)</sub>

</summary>

<details>

<summary>
run CLI

</summary>

```bash
$>docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
```

This creates a container named some-postgres and assigns important environment variables before running everything in the background. Postgres requires a password to function properly, which is why that’s included. 

If you have this password already, you can spin up a Postgres container within Docker Desktop. Just click that aforementioned “Run” button beside your image, then manually enter this password within the “Optional Settings” pane before proceeding. 
However, you can also use the Postgres interactive terminal, or psql, to query Postgres directly:

```bash
$>docker run -it --rm --network some-network postgres psql -h some-postgres -U postgres
#output: 
`psql (14.3)
Type "help" for help.
postgres=# SELECT 1;
 ?column?

(1 row)`
```

</details>

<details>
<summary>
Compose

</summary>

```yaml
# compose.yml
services:
 
  db:
    image: postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: example
    volumes:
- pgdata:/var/lib/postgresql/data
 
volumes:
  pgdata:
 
  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080
```

</details>

---

<sub>

[Docker Docs](https://www.docker.com/blog/how-to-use-the-postgres-docker-official-image/) - Online - PostgreSQL
</sub>

</details>

---

---

### SonarQube Server

Pick solution best suited for use case.

#### Docker

<details>

<summary>
Commands
</summary>

##### Containers

<details>

<summary>
Create containers using <q>Docker Network</q>

</summary>

****Create Docker network****

```bash
$> docker network create sonarnet
```

****Run PosgreSQL Database:****

```bash
$. docker run --name sonarqube-db --network sonarnet -e POSTGRES_USER=sonar -e POSTGRES_PASSWORD=sonar -v postgresql:/var/lib/postgresql -v postgresql_data:/var/lib/postgresql/data -d postgres:12
```

****Run SonarQube:****

```bash
$> docker run --name sonarqube --network sonarnet -e SONAR_JDBC_URL=jdbc:postgresql://sonarqube-db:5432/sonar -e SONAR_JDBC_USERNAME=sonar -e SONAR_JDBC_PASSWORD=sonar -v sonarqube_data:/opt/sonarqube/data -v sonarqube_extensions:/opt/sonarqube/extensions -v sonarqube_logs:/opt/sonarqube/logs -p 9000:9000 -d sonarqube:developer
```

</details>

<details>

  <summary>
Create containers using
<del  style="color:red" >
<q>
Docker Link
</q>
Legacy/Depercated
</del>

  </summary>

the `--link` is outdated, use compose or `--network` instead.

**PostreSQL:**

```bash
$> docker run --name sonarqube-db -e POSTGRES_USER=sonar -e POSTGRES_PASSWORD=sonar -v postgresql:/var/lib/postgresql -v postgresql_data:/var/lib/postgresql/data -d postgres:12
```

**SonarQube:**

```bash
$> docker run --name sonarqube -e SONAR_JDBC_URL=jdbc:postgresql://sonarqube-db:5432/sonar -e SONAR_JDBC_USERNAME=sonar -e SONAR_JDBC_PASSWORD=sonar -v sonarqube_data:/opt/sonarqube/data -v sonarqube_extensions:/opt/sonarqube/extensions -v sonarqube_logs:/opt/sonarqube/logs -p 9003:9003 --link sonarqube-db -d sonarqube:developer
```

</details>

</details>

### Docker Compose

<details>
<summary>
Files

</summary>

```yaml
version: "3"

services:
  sonarqube:
    image: sonarqube:community
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

> ### :warning: Note
>
> Unless you intend to delete the database and start new when running your image ,be careful not to use -v to docker-compose down and, be careful when running commands like docker system prune or docker volume prune; regardless if you use an external: true parameter, your database volumes will not persist beyond the initial startup and shutdown of SonarQube.

</details>

<details>

<summary>
Commands

</summary>

---

Startup SonarQube Docker Compose instance

```bash
$> docker compose up -d
```

Alteritive Docker command???

 <!-- ```bash
$> docker run -d --name sonarqube-db \
-p -->
```

```bash
$> docker run -d --name sonarqube \
    -p 9000:9000 \
    -e SONAR_JDBC_URL=... \ 
    -e SONAR_JDBC_USERNAME=... \
    -e SONAR_JDBC_PASSWORD=... \
    -v sonarqube_data:/opt/sonarqube/data \
    -v sonarqube_extensions:/opt/sonarqube/extensions \
    -v sonarqube_logs:/opt/sonarqube/logs \
    sonarqube:developer
  ```

</details>

<!-- docker compose section end -->

<h3 id="zip-file">Zip File <sub>(local istall)</sub></h3>

<details>

<summary>
More

</summary>

1. [Download](https://www.sonarsource.com/products/sonarqube/downloads/) source files from host. 
2. Check out the [Docs](https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/install-the-server/installing-sonarqube-from-zip-file/)

<details>

<summary>
<samp>
${sonarqubeHome}/conf/sonar.properties

</samp>

</summary>

```properties
sonar.path.data=/var/sonarqube/data
sonar.path.temp=/var/sonarqube/temp
```

</details>

<!-- END : Installation - Zip file -->
</details>

### Homebrew

<details>

<summary>
Install

</summary>

<code>

<kbd>
$>brew install sonarqube sonar-scanner

</kbd>
  
<samp>To start sonarqube now and restart at login:
  brew services start sonarqube
Or, if you don't want/need a background service you can just run:
  /usr/local/opt/sonarqube/bin/sonar console
==> Summary
🍺  /usr/local/Cellar/sonarqube/10.3.0.82913: 313 files, 420.5MB
==> Running `brew cleanup sonarqube`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
</samp>

</code>

</details>

<details>

<summary>
Starting SonarQube Service

</summary>

```bash
# --- Start at login
$>brew services start sonarqube

# --- or start without background service
$>/usr/local/opt/sonarqube/bin/sonar console
```

</details>

<details>

<summary>
Scanning repositorie on local

run cmd in repo root dir:

```bash

$>sonar-scanner \
  -Dsonar.projectKey=${project_key} \
  -Dsonar.sources=. \
  -Dsonar.host.url=${host_url} \
  -Dsonar.token=${token}
```

</summary>

</details>
<!-- End : Installation - Homebrew -->

---

---

<!-- END SECTION : Installation -->

## Configuration Settings and Setup

### Addtional Files

<details>

<summary>
SonarQube
</summary>

If running outside of docker container add file `sonarqube/conf/sonar.properities` with obtained values

```properties
sonar.jdbc.username=${DB_USERNAME}
sonar.jdbc.password=${DB_PASSWORD}
sonar.jdbc.url=${DB_CONNECT}
sonar.path.data=${PATH_TO_DATA}
sonar.path.temp=${PATH_TO_TEMP}
```

If running from [docker continer or compose](#docker). This should have been set a when starting the instance.

<!-- <details> -->

<!-- <summary>
Steps

</summary>

- create project
  - select local setup
  - select analysis profile
- generate token for authentication
- add file: [`${root_dir}/sonar-project.properties`](#sonar-project-properties) to the repo to be scanned.

</details> -->

</details>

<details>

<summary>
Code Repository

</summary>

Add file to code source repository.

<details>

<summary>
<samp id="sonar-project-properties">&lt;rootDir&gt;/sonar-project.properties<samp>

</summary>

```properties
sonar.projectKey=<project name>
```

</details>

### BitBucket

- [ ]  In repo settings turn on piplines. [Add config Yaml file to repository](https://support.atlassian.com/bitbucket-cloud/docs/configure-your-first-pipeline/)

</details>

---

Access SonarQube Docker container shell

Shell command:

```bash
$>sudo docker exec -it sonarqube-sonarqube-1
```

---
