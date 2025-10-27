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