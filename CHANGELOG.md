# Changelog
## 1.10.0 (2025-04-03)
- Added extra sources

### deploy instructions
```
drc restart migrations
```
Ensure in docker-compose.override.yml
```
  worship-services-sensitive-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"
      DCR_SYNC_BASE_URL: 'https://loket.lokaalbestuur.vlaanderen.be/'
      DCR_SYNC_LOGIN_ENDPOINT: 'https://loket.lokaalbestuur.vlaanderen.be/sync/worship-services-sensitive/login'
      DCR_SECRET_KEY: 'shared key with producer stack'
  submissions-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"
      DCR_SYNC_BASE_URL: 'https://loket.lokaalbestuur.vlaanderen.be/'
      DCR_SYNC_LOGIN_ENDPOINT: 'https://loket.lokaalbestuur.vlaanderen.be/sync/worship-submissions/login'
      DCR_SECRET_KEY: "shared key with producer stack"
  subsidies-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"
      DCR_SYNC_BASE_URL: 'https://subsidiepunt.abb.vlaanderen.be/'
      DCR_SYNC_LOGIN_ENDPOINT: 'https://subsidiepunt.abb.vlaanderen.be/sync/subsidies/login'
      DCR_SECRET_KEY: "shared key with producer stack"
```

## 1.9.0 (2025-03-20)
- Switch OP master [DL-6496]
### deploy instructions
```
drc down
drc up -d migrations
drc up -d database op-public-consumer # wait for initial sync to finish
drc up -d
```
## 1.8.1 (2025-03-19)
- Add missing docker compose keys. [DL-6490]
### Deploy Notes
```
drc up -d database delta-notifier m2m-login
```
## 1.8.0 (2025-03-17)
### General
  - Big maintenance job: extra data sources, new mu-auth and m2m ACM login: see [PR](https://github.com/lblod/app-digitaal-loket-data-warehouse/pull/7)
## 1.7.2 (2023-08-20)
- Restore `version` attribute for `docker-compose.yml`
  - Removing it seems to break the config on v1 of `docker-compose`.
### Deploy Notes
#### Docker Commands
- `drc up -d yasgui identifier dispatcher database migrations mandatendatabank-consumer leidinggevenden-consumer persons-sensitive-consumer subsidies-consumer web`
## 1.7.1 (2023-08-20)
- Add missing `restart`, `logging` and `labels` attributes. (DL-6136)
## 1.7.0 (2023-11-30)
- bump consumers
- bump identifier
## 1.6.0 (2022-10-21)
- extra migration
## 1.5.0 (2022-10-21)
- fix resultaten
## 1.4.0 (2022-10-21)
- fix kieslijsten
## 1.3.0 (2022-10-11)
- added verkiezingsresultaten Bilzen
## 1.2.0 (2022-04-15)
- added migration containing provincies
## 1.1.0 (2022-04-13)
- persons-consumer
- subsidies-consumer
## 1.0.0 (2022-03-24)
- Release major
