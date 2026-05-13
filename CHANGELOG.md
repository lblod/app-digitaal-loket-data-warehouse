# Changelog
## 2.0.0 (2026-05-11)
- Added data-monitoring-service [DL-7284]
- Use OP Model [DL-7276]

### deploy instructions
Ensure initial syncs are enabled in `docker-compose.override.yml`:
```
  leidinggevenden-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"
  persons-sensitive-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"
  mandatendatabank-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"
  op-public-consumer:
    environment:
      DCR_DISABLE_INITIAL_SYNC: "false"
```

Baseline monitoring run (kept for later comparison):
```
drc exec data-monitoring curl -X POST http://localhost/monitoring-runs
```

Apply migrations (OP normalization + full flush of all landing zones and the datawarehouse graph) and restart affected services:
```
drc restart migrations
drc restart database
drc restart op-public-consumer
```

Alternative: skip the flush migration and wipe `./data/` instead (stop the stack, back up or `rm -rf data/`, start the stack). Simpler, but you lose the baseline monitoring run.

Re-trigger initial sync on the affected consumers:
```
for c in leidinggevenden-consumer persons-sensitive-consumer mandatendatabank-consumer op-public-consumer; do
  drc exec $c curl -X DELETE http://localhost/initial-sync-jobs
  drc exec $c curl -X POST http://localhost/initial-sync-jobs
done
```

Verification monitoring run (compare with baseline):
```
drc exec data-monitoring curl -X POST http://localhost/monitoring-runs
```

# 1.11.1 (2026-05-07)
- Bump virtuoso [DL-7343]

## 1.11.0 (2026-05-05)
- Added pro-active data monitoring (PRs #11, #13): new services `data-monitoring`, `scheduled-job-controller`, `deliver-email`, plus mailbox/scheduled-job migrations, new authorization graphs and scope, new delta rules, and `database` bumped to `sparql-parser:0.0.15`.

### deploy instructions
Set `EMAIL_FROM` / `EMAIL_TO` on `data-monitoring` in `docker-compose.override.yml`.
```
drc restart migrations
drc up -d database
drc restart delta-notifier
drc up -d data-monitoring scheduled-job-controller deliver-email
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
