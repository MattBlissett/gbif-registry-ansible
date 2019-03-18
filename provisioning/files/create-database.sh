cat << EOF | sudo -u postgres psql
-- Create the database users:
CREATE USER registry WITH PASSWORD 'registry';

-- Create the databases:
CREATE DATABASE registry WITH OWNER registry;

\c registry;

CREATE EXTENSION hstore;
EOF
