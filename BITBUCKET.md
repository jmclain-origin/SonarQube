# BitBucket Integration

<details>

<summary>
Offical Documentation
</summary>

[SonarQube Bitbucket Intergration](https://docs.sonarsource.com/sonarqube/latest/devops-platform-integration/bitbucket-integration/bitbucket-cloud-integration/)

From the SonarQube dashbroad you'll be prompted for the following items:

- [Bitbucket OAuth consumer](https://support.atlassian.com/bitbucket-cloud/docs/use-oauth-on-bitbucket-cloud/)

- [Bitbucket Username](https://bitbucket.org/account/settings/)

- [BitBucket App Password](https://bitbucket.org/account/settings/app-passwords/)

> ☝️ Once successful you'll have an option to create a project from the  repositories hosted on your [Bitbucket](https://bitbucket.org)

</details>

## Configuration

After Creating/Linking your projects in SonarQube, you will be prompted to select a **Analysis Method**

Select -> BitBucket CI

[<sub>*Get started with Bitbucket Pipelines*</sub>](https://support.atlassian.com/bitbucket-cloud/docs/get-started-with-bitbucket-pipelines/)

Still in SonarQube, on the next screen you can generate a token to be used to verify the remote repository.

Add environment variables to BitBucket repository settings.

- SONAR_TOKEN
- SONAR_HOST_URL

Create and add Sonar project properties file to root directory of repository  
  `sonar-project.properties`

```javascript
example. 
 the value will be generated automatically in SonarQube project
sonar.projectKey=<workspace_id><project_id><uuid>

```

Create and add pipeline config file to root directory of repository  
  `bitbucket-pipeline.yml`

```yaml
# Pipeline example for Node.js project and SonarQube scan
image: node:16

clone:
  depth: full
definitions:
  caches:
    sonar: ~/.sonar/cache
  steps:
    - step: &build
        name: NodeJs Build
        caches:
          - node
        script:
          - yarn install
          # - yarn test
          - yarn build
    - step: &sonarqube
        name: SonarQube Scan
        script:
          - pipe: sonarsource/sonarqube-scan:2.0.1
            variables:
              SONAR_TOKEN: ${SONAR_TOKEN}
              SONAR_HOST_URL: ${SONAR_HOST_URL}
pipelines:
  branches:
    main:
      - step: *build
      - step: *sonarqube
    develop:
      - step: *build
      - step: *sonarqube
```
