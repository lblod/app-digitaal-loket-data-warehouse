# Changelog
## Unreleased
- Added data-monitoring-service [DL-7284]
- Use OP Model [DL-7276]

### deploy instructions
#### 1. Baseline monitoring run (before any changes)
```
docker compose exec data-monitoring curl -X POST http://localhost/monitoring-runs
```
##### Wait for "Monitoring run completed" in logs
```
docker compose logs data-monitoring --tail 5
```
#### 2. Deploy the code
```
git pull  # or checkout the branch
```
#### 3. Run migrations
Runs the normalization migration (persoon http→https, remove besluit:classificatie, etc.) followed by the Loket consumer data flush.

```
drc up -d migrations
```
##### Wait for "All migrations executed" in logs
```
docker compose logs migrations --tail 20
```
#### 4. Restart auth / sparql-parser
```
drc restart database
```
#### 5. Restart op-public-consumer
Picks up removed classification/isTijdspecialisatieVan mappings + new skos:Concept CONSTRUCTs.
```
drc up -d op-public-consumer
```
#### 6. Re-sync Loket consumers
The 3 consumers now have triple remapping enabled. Delete their completed initial sync jobs and trigger fresh syncs to populate the landing zones.


##### leidinggevenden
```
docker compose exec leidinggevenden-consumer curl -X DELETE http://localhost/initial-sync-jobs
docker compose exec leidinggevenden-consumer curl -X POST http://localhost/initial-sync-jobs
```
##### persons-sensitive
```
docker compose exec persons-sensitive-consumer curl -X DELETE http://localhost/initial-sync-jobs
docker compose exec persons-sensitive-consumer curl -X POST http://localhost/initial-sync-jobs
```
##### mandatendatabank
```
docker compose exec mandatendatabank-consumer curl -X DELETE http://localhost/initial-sync-jobs
docker compose exec mandatendatabank-consumer curl -X POST http://localhost/initial-sync-jobs
```
#### 7. Re-sync OP consumer
Identifier/GestructureerdeIdentificator were flushed (shared types). Re-sync to repopulate.
```
docker compose exec op-public-consumer curl -X DELETE http://localhost/initial-sync-jobs
docker compose exec op-public-consumer curl -X POST http://localhost/initial-sync-jobs
```
#### 8. Wait for all syncs to complete
Monitor progress:
```
docker compose logs --tail 5 leidinggevenden-consumer persons-sensitive-consumer mandatendatabank-consumer op-public-consumer
```
#### 9. Verification monitoring run
```
docker compose exec data-monitoring curl -X POST http://localhost/monitoring-runs
```
##### Wait for completion
```
docker compose logs data-monitoring --tail 5
```
Compare counts with the baseline from step 1. Expected changes:
```
ABI-1384-Status, ABI-1385-TypeEredienst, ABI-1382-Events, ABI-1396-ChangeEvents: non-zero (were 0)
ABI-1399-Persoon completeness_nationaliteit: ~8,600 (was 0)
ABI-1399-Persoon completeness_geboortedatum/geslacht: ~30k (was ~21k)
```


## 1.10.1 (2025-07-18)
- Added empty configuration for delta-notifier
- Bumped mu-identifier for use of scopes

### deploy instructions
```
drc restart delta-notifier
drc up -d identifier
```

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
