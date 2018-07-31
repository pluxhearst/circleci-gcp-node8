<div align="center">
  <img width="200" height="200"
    src="https://cdn.worldvectorlogo.com/logos/circleci.svg">

  <h1>CircleCI 2.0 Node 8.2 Build container</h1>
  <p>Docker Repository for the pierolucianihearst NodeJS CircleCI build & deployment Image.<p>
</div>

### Usage
```bash
# config.yml
    docker:
      - image: pierolucianihearst/circleci-gcp-node8
```

Essentially it's circleci/node:8.2.0 + NVM + Google Cloud SDK. The SDK is not initialized in this build, that is done during the CI run using secure environment variables ( see the [gpc docs](https://circleci.com/docs/2.0/google-container-engine/) ).

The container does not have a headless browser configuration ( We use Jest because in-browser testing is over ) 
