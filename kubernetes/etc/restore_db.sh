#!/bin/bash

DB_NAME=schedule
DB_USER=super_mega_user


kubectl exec pod/postgres-0 -- psql -U $DB_USER -d $DB_NAME -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
cat etc/$DB_NAME.dump.sql | kubectl exec -i pod/postgres-0 -- psql -U $DB_USER -d $DB_NAME
