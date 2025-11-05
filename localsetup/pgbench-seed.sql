-- pgbench custom script to seed one status + details row per transaction
-- Schema from Flyway V1__init.sql:
--   "BerechnungStatus"(id UUID default gen_random_uuid(), status TEXT NOT NULL, started_at TIMESTAMPTZ default now())
--   "BerechnungDetails"(id UUID default gen_random_uuid(), status_id UUID NOT NULL REFERENCES "BerechnungStatus"(id), details TEXT)
--
-- Each run of this script (one transaction) inserts:
--   1 row into "BerechnungStatus" with a random status
--   1 row into "BerechnungDetails" referencing the inserted status
--
-- Safe to run concurrently. Primary keys are UUIDs generated in DB.

-- pgbench variables (per transaction)
\set bid random(1,1000000000)

BEGIN;

-- Insert status row and then a details row referencing it, in a single CTE
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
-- NOTE: Escape colons in the format string so pgbench doesn't treat :MI / :SS as variables
INSERT INTO "BerechnungDetails"(status_id, details)
SELECT id,
       'Initial seed via pgbench; client=' || :client_id || ', bid=' || :bid ||
       ', ts=' || to_char(clock_timestamp(), 'YYYY-MM-DD"T"HH24\:MI\:SS.US')
FROM ins;

COMMIT;
