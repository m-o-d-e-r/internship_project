#!/bin/bash
set -e

until psql -U "$POSTGRES_USER" -h "$DB_HOST" -d "$POSTGRES_DB" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing commands"

psql -U "$POSTGRES_USER" -h "$DB_HOST" -d "$POSTGRES_DB" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
psql -U "$POSTGRES_USER" -h "$DB_HOST" -d "$POSTGRES_DB" -f /dump.sql

echo "DB restored successfully"
