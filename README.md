# SonarQube

Table of Contents:

1. [Overview](#overview)

<details>

<summary>

2. [Installation](#installation)

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

<details>

<summary>
Versions/Images

</summary>

- Commitiy edition `sonarqube:commitiy`
- Developer edition<sup>*</sup> `sonarqube:developer`
- Enterprise edition<sup>*</sup> `sonarqube:enterprise`

<sup>_* - Requires Lincense_</sup>

**Community is free.**

**[Get a 14 day free trail license here](https://www.sonarsource.com/products/sonarqube/developer-edition/marketplace/?serverId=243B8A4D-AYxfui1Aune7s8eXOfbP&ncloc=0&sourceEdition=developer)**

</details>

<!-- End of Configuration section -->

---

<!-- ## Local analiys configuration -->


---

## Installation

Prerequites

- SonarQube
  - Java >=11 (JDK - JRE)

- Database
  - *Only one needed*
    - PostgreSQL
    - MicrosoftSQL server
    - JDBC

### Database

Several external database engines are supported. Be sure to follow the requirements listed for your database. They are real requirements not recommendations.

Create an empty schema and a sonarqube user. Grant this sonarqube user permissions to create, update, and delete objects for this schema.

<sub>

*see [online docs](https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/install-the-server/installing-the-database/) for furthur information*

</sub>

---

## SonarQube Server

Pick solution best suited for use case.

### Docker
<!-- ```bash
$> docker run -d --name sonarqube-db \
-p 

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
  ``` -->

<details>

<summary>
Commands
</summary>

#### Containers

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

</details>

<details>

<summary>
Commands

</summary>

- Startup SonarQube Docker Compose instance

```bash
$> docker compose up -d
```

</details>

<!-- docker compose section end -->

### Zip File

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
$>brew install sonarqube

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
Starting SonarQube server

</summary>

```bash
# --- Start at login
$>brew services start sonarqube

# --- or start without background service
$>/usr/local/opt/sonarqube/bin/sonar console
```

</details>

<!-- End : Installation - Homebrew -->

---

<!-- END SECTION : Installation -->

## Configuration Settings and Setup

### Global

<details>

<summary>
SonarQube
</summary>

### Local

<details>

<summary>
Steps

</summary>

- create project
  - select local setup
  - select analysis profile
- generate token for authentication
- add file: [`${root_dir}/sonar-project.properties`](#sonar-project-properties) to the repo to be scanned.

</details>

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
