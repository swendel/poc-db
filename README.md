# Was ist hier zu finden
- SpringBoot Anwendung mit REST-Endpunkt und Spring-Data Zugriff auf die Datenbanken
- Verzeichnis /localsetup mit docker compose Konfig, die
  - Postgres-Cluster (ein primary und ein replica) für Tests Replication, write/read-Trennung etc.
  - Cockroach-Cluster (3 nodes)
  - todo: 3 standalone Postgres-Instanzen (für Tests Client-Side-Sharding)

# Installation Teil 1: Datenbanken per docker compose starten
- Vorher: Docker installiert, Docker compose installiert
- cd /localsetup
- docker compose up --force-recreate

## Installation Teil 2: SpringBoot-App bauen und per Docker starten
Voraussetzung: Docker ist installiert. Im Projektwurzelverzeichnis (wo das Dockerfile liegt) ausführen:

```bash
docker build -t poc-db:latest .
```

Anschließend kann der Container z. B. so gestartet werden (mindestens DB_HOST setzen; die restlichen Werte haben gute Defaults in application.yml):

```bash
docker run --rm -p 8080:8080 -e DB_HOST=host.docker.internal poc-db:latest
```

Hinweis (Linux): Falls host.docker.internal nicht auflöst, nutze zusätzlich:

```bash
docker run --rm --add-host=host.docker.internal:host-gateway -p 8080:8080 -e DB_HOST=host.docker.internal poc-db:latest
```

# how to run load-tests
- Tool der Wahl: hey
- Verzeichnis /loadtest
- Dort Bash Skript ausführen (Erklärung in Skript). Per Default werden 100 Datensätze angelegt

# How to call REST-Endpoint
- Siehe Bruno-Skript unter "bruno-collections"
- Dort Request mit einem Post abgelegt
- Bei Erzeugen eines BerechnungsDetails Eintrages in der DB wird automatisch auch ein BerechnungsStatus gesetzt

# how to shut down Databases
- docker compose down -v (-v damit auch die Voulmes und somit die Daten in den DBs gelöscht werden)

## Weitere Info: Datenbank-Verbindung konfigurieren, wenn die App via Docker gestartet wird

Wird die SpringBoot App ohne Docker gestartet (z.B. durch run in der IDE), dann muss der DB_HOST auf localhost gehen

DB-Parameter werden über Umgebungsvariablen gesteuert (mit sinnvollen Defaults):
- DB_HOST (Default: localhost, bei Start via Docker: host.docker.internal)
- DB_PORT (Default: 55432)
- DB_NAME (Default: app_db)
- DB_USER (Default: app)
- DB_PASSWORD (Default: app_password)

Diese Variablen füllen die Spring-Properties in src/main/resources/application.yml:
- spring.datasource.url=jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}
- spring.datasource.username=${DB_USER}
- spring.datasource.password=${DB_PASSWORD}

Beispiele:
- siehe "docker run" weiter oben
- Wird Docker aus einer IDE heraus gestartet (z.B. IntelliJ) dann die o.g. Port-Bindings (8080:8080) und die ENV-Variablen (mindestens DB_HOST) in der IDE setzen
