-- Migration 019: Fix event_staff schema (only if needed)

-- Drop old event_staff table first
DROP TABLE IF EXISTS event_staff CASCADE;

-- Recreate event_staff with final schema
CREATE TABLE event_staff (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id        UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    organizer_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    email           TEXT NOT NULL,
    phone_number    TEXT NOT NULL,
    access_token    UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    is_revoked      BOOLEAN NOT NULL DEFAULT FALSE,
    tickets_scanned INTEGER NOT NULL DEFAULT 0,
    last_active_at  TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT event_staff_unique_email UNIQUE (event_id, email)
);

CREATE INDEX idx_event_staff_event     ON event_staff(event_id);
CREATE INDEX idx_event_staff_token     ON event_staff(access_token);
CREATE INDEX idx_event_staff_organizer ON event_staff(organizer_id);