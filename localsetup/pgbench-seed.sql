-- pgbench‑Skript, das pro Transaktion eine Status‑ und eine Detail‑Zeile erzeugt
-- Schema aus Flyway V1__init.sql:
--   "BerechnungStatus"(id UUID default gen_random_uuid(), status TEXT NOT NULL, started_at TIMESTAMPTZ default now())
--   "BerechnungDetails"(id UUID default gen_random_uuid(), status_id UUID NOT NULL REFERENCES "BerechnungStatus"(id), details TEXT)
--
-- Jeder Lauf dieses Skripts (eine Transaktion) fügt ein:
--   1 Zeile in "BerechnungStatus" mit zufälligem Status
--   1 Zeile in "BerechnungDetails", die auf den eingefügten Status verweist
--
-- Sicher parallel auszuführen. Primärschlüssel sind UUIDs und werden in der DB generiert.

-- pgbench‑Variablen (pro Transaktion)
\set bid random(1,1000000000)

BEGIN;

-- In einer einzigen CTE: zuerst eine Status-Zeile einfügen, dann eine verweisende Details-Zeile
WITH sel AS (
  SELECT CASE ((floor(random()*3))::int)
           WHEN 0 THEN 'NEW'
           WHEN 1 THEN 'RUNNING'
           WHEN 2 THEN 'DONE'
         END AS status
), ins AS (
  INSERT INTO "BerechnungStatus"(status)
  SELECT COALESCE(status, 'NEW') FROM sel
  RETURNING id
)
-- Hinweis: Doppelpunkte in der Format-String-Maske escapen, damit pgbench :MI / :SS nicht als Variablen interpretiert
INSERT INTO "BerechnungDetails"(status_id, details)
SELECT id,
       'Initial seed via pgbench; client=' || :client_id || ', bid=' || :bid ||
       ', ts=' || to_char(clock_timestamp(), 'YYYY-MM-DD"T"HH24\:MI\:SS.US')
FROM ins;

COMMIT;
