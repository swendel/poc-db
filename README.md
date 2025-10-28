# Was ist hier zu finden
- SpringBoot Anwendung mit REST-Endpunkt und Spring-Data Zugriff auf die Datenbanken
- Verzeichnis /localsetup mit docker compose Konfig, die
  - Postgres-Cluster (ein primary und ein replica) für Tests Replication, write/read-Trennung etc.
  - Cockroach-Cluster (3 nodes)
  - 3 standalone Postgres-Instanzen (für Tests Client-Side-Sharding)

# how to install
- Vorher: Docker installiert, Docker compose installiert
- cd /localsetup
- docker compose up --force-recreate
- SpringBoot Anwendung bauen: mvn clean install
- Spring Boot Anwendung starten

# how to run load-tests
- Tool der wahl: hey
- Verzeichnis /loadtest
- Dort Bash Skript ausführen (Erklärung in Skript)

# How to call REST-Endpoint
- Siehe Bruno-Skript unter "bruno-collections"
- Dort Request mit einem Post abgelegt
- Bei Erzeugen eines BerechnungsDetails Eintrages in der DB wird automatisch auch ein BerechnungsStatus gesetzt

# how to shut down
- docker compose down -v (-v damit auch die Voulmes und somit die Daten in den DBs gelöscht werden)

## Datenbank-Verbindung konfigurieren, wenn die App via Docker gestartet wird
Die App war bisher fest auf 127.0.0.1:55432 konfiguriert. In einem Docker-Container zeigt 127.0.0.1 jedoch auf den Container selbst – daher kam der Fehler "Connection to 127.0.0.1:55432 refused".

DB-Parameter werden über Umgebungsvariablen gesteuert (mit sinnvollen Defaults):
- DB_HOST (Default: host.docker.internal)
- DB_PORT (Default: 55432)
- DB_NAME (Default: app_db)
- DB_USER (Default: app)
- DB_PASSWORD (Default: app_password)

Diese Variablen füllen die Spring-Properties in src/main/resources/application.yml:
- spring.datasource.url=jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}
- spring.datasource.username=${DB_USER}
- spring.datasource.password=${DB_PASSWORD}

Beispiele:
- App als Docker-Container, Zugriff auf Postgres aus localsetup (Host-Port 55432):
  docker run --rm -p 8080:8080 \
    -e DB_HOST=host.docker.internal -e DB_PORT=55432 \
    -e DB_NAME=app_db -e DB_USER=app -e DB_PASSWORD=app_password \
    poc-db:latest

- Wird Docker aus einer IDE heraus gestartet (z.B. IntelliJ) dann die o.g. Port-Bindings (8080:8080) und die ENV-Variablen (mindestens DB_HOST) in der IDE setzen
