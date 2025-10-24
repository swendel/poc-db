-- Schema for required tables
CREATE TABLE IF NOT EXISTS "BerechnungStatus" (
    id BIGSERIAL PRIMARY KEY,
    status TEXT NOT NULL,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS "BerechnungDetails" (
    id BIGSERIAL PRIMARY KEY,
    status_id BIGINT NOT NULL REFERENCES "BerechnungStatus"(id) ON DELETE CASCADE,
    details TEXT
);
