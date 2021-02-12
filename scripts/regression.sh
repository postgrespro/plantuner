#!/usr/bin/env bash

set -ex

export DEBIAN_FRONTEND=noninteractive
apt update
apt install -y curl ca-certificates gnupg lsb-release build-essential
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
apt update

export PGUSER=postgres
export PGDATABASE=postgres
export PGPORT=5432

VER=$1

apt install -y "postgresql-$VER" "postgresql-server-dev-$VER"
echo 'local all all trust' > "/etc/postgresql/$VER/main/pg_hba.conf"
/etc/init.d/postgresql start
export PG_CONFIG="/usr/lib/postgresql/$VER/bin/pg_config"
make clean && make && make install
psql -Atc 'alter system set shared_preload_libraries to plantuner'
/etc/init.d/postgresql restart
make installcheck
