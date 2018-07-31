<div align="center">
  <img width="100" height="100" src="https://cdn.worldvectorlogo.com/logos/circleci.svg" />
  <img width="100" height="100" src="https://cdn.worldvectorlogo.com/logos/nodejs.svg" />
  <img width="100" height="100" src="https://cdn.worldvectorlogo.com/logos/google-cloud.svg" />
  <img width="100" height="100" src="https://cdn.worldvectorlogo.com/logos/php-1.svg" />
  <img width="100" height="100" src="https://cdn.worldvectorlogo.com/logos/composer.svg" />
  <h1>CircleCI 2.0 + Node 8.2 + Google Cloud SDK + php5 php5-cli + PHP Composer + Build container</h1>
  <p>Docker Repository for the pierolucianihearst Image.<p>
</div>

### Usage
```bash
# config.yml
    docker:
      - image: pierolucianihearst/circleci-gcp-node8
```

It's circleci 2.0 + node:8.2.0 + NVM + Google Cloud SDK + php5 php5-cli + PHP Composer. 
The SDK is not initialized in this build, that is done during the CI run using secure environment variables ( see the [gpc docs](https://circleci.com/docs/2.0/google-container-engine/) ).

The container does not have a headless browser configuration ( We use Jest because in-browser testing is over ) 