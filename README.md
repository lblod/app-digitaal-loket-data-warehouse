# Digitaal Loket Data warehouse

Started from the [mu-project](https://github.com/mu-semtech/mu-project) template.

## Running and maintaining

General information on running, maintaining and installing the stack.

### How to start the stack

> **Prerequisites**
> - [docker](https://docs.docker.com/get-docker/), [docker-compose](https://docs.docker.com/get-docker/) and [git](https://git-scm.com/downloads) are installed on your system
> - you've [cloned the repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

Start the system:
```shell
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
```
> docker-compose **up** CLI [reference](https://docs.docker.com/compose/reference/up/).

Wait for everything to boot to ensure clean caches. You may choose to monitor the migration service in a separate terminal and 
wait for the overview of all migrations to appear:

```shell
docker-compose logs -f --tail=100 migrations
```
> docker-compose **logs** CLI [reference](https://docs.docker.com/compose/reference/logs/).

#### With environement variables
You might find the above `docker-compose up` command tedious. To simplify it's usage we can define the `COMPOSE_FILE` variable in our environment.

Create an `.env` file in the root of the project with the following contence:
```shell
COMPOSE_FILE=docker-compose.yml:docker-compose.dev.yml
```
> docker-compose CLI env. vars. [reference](https://docs.docker.com/compose/reference/envvars/)

Start the system:
```shell
docker-compose up
```

### Sync data from external sources
#### delta-consumers
:warning: By default, the delta-consumers won't start to sync automatically. There are many of them, and you risk overloading the database.

Additionally, some consumers are linked to private streams, so API keys should be provided.

Finally, all consumers are directed to QA by default. You'll need to update the endpoint if you want other sources.

Update `docker-compose.override.yml` for this.

Here is an example of how it looks for production, excluding the keys.

```
version: '3.7'

services:
  leidinggevenden-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"  # setting this to "false" will start the consumer (yes confusing sorry about that)
      DCR_SYNC_BASE_URL: 'https://loket.lokaalbestuur.vlaanderen.be/'
  persons-sensitive-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"  # setting this to "false" will start the consumer (yes confusing sorry about that)
      DCR_SYNC_BASE_URL: 'https://loket.lokaalbestuur.vlaanderen.be/'
      DCR_SYNC_LOGIN_ENDPOINT: 'https://loket.lokaalbestuur.vlaanderen.be/sync/persons-sensitive/login'
      DCR_SECRET_KEY: '<enter key here>'
  mandatendatabank-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"  # setting this to "false" will start the consumer (yes confusing sorry about that)
      DCR_SYNC_BASE_URL: 'https://loket.lokaalbestuur.vlaanderen.be/'
  op-public-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"  # setting this to "false" will start the consumer (yes confusing sorry about that)
      DCR_SYNC_BASE_URL: "https://organisaties.abb.vlaanderen.be"
  worship-services-sensitive-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"  # setting this to "false" will start the consumer (yes confusing sorry about that)
      DCR_SYNC_BASE_URL: 'https://loket.lokaalbestuur.vlaanderen.be/'
      DCR_SYNC_LOGIN_ENDPOINT: 'https://loket.lokaalbestuur.vlaanderen.be/sync/worship-services-sensitive/login'
      DCR_SECRET_KEY: '<enter key here>'
  submissions-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"  # setting this to "false" will start the consumer (yes confusing sorry about that)
      DCR_SYNC_BASE_URL: 'https://loket.lokaalbestuur.vlaanderen.be/'
      DCR_SYNC_LOGIN_ENDPOINT: 'https://loket.lokaalbestuur.vlaanderen.be/sync/worship-submissions/login'
      DCR_SECRET_KEY: '<enter key here>'
  subsidies-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"  # setting this to "false" will start the consumer (yes confusing sorry about that)
      DCR_SYNC_BASE_URL: 'https://subsidiepunt.abb.vlaanderen.be/'
      DCR_SYNC_LOGIN_ENDPOINT: 'https://subsidiepunt.abb.vlaanderen.be/sync/subsidies/login'
      DCR_SECRET_KEY: '<enter key here>'
```
See [delta-consumer](https://github.com/lblod/delta-consumer) for more info.
