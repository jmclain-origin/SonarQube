# SonarQube

Community Edition

Run local server using docker compose file

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

```bash
$> docker compose up -d
```

---
### **defalut login**

username: `admin`

password: `admin`

--- 

### Developer Edition

update compose file image with, 
```yaml
services:
  sonarqube:
    image: sonarqube:developer
```

**Requires license. [Get a 14 day free trail license here](https://www.sonarsource.com/products/sonarqube/developer-edition/marketplace/?serverId=243B8A4D-AYxfui1Aune7s8eXOfbP&ncloc=0&sourceEdition=developer)**

