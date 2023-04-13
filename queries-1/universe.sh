#!/bin/bash

# Define variables
DB_NAME="postgres"
DB_USER="freecodecamp"
DB_PASSWORD=""
SQL_FILE="run.sql"

# Run SQL script
psql -d "$DB_NAME" -U "$DB_USER" -W "$DB_PASSWORD" -f "$SQL_FILE"