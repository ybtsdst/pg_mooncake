#!/bin/bash

PG_FEATURE=pg18

workspace_root=/opt/transwarp/pg_mooncake
PG_VERSION=$(cargo pgrx info version ${PG_FEATURE})
PG_LIB_DIR="${workspace_root}/target/release/pg_mooncake-${PG_FEATURE}/home/dev/.pgrx/${PG_VERSION}/pgrx-install/lib/postgresql/"
PG_EXTENSION_DIR="${workspace_root}/target/release/pg_mooncake-${PG_FEATURE}/home/dev/.pgrx/${PG_VERSION}/pgrx-install/share/postgresql/extension/"

rm -rf ./pg_mooncake-*.tar.gz
rm -rf ./dist && mkdir -p ./dist

cp ${PG_LIB_DIR}/pg_mooncake.so ./dist/
cp ${PG_EXTENSION_DIR}/pg_mooncake--*.sql ./dist/
cp ${PG_EXTENSION_DIR}/pg_mooncake.control ./dist/

tar czf pg_mooncake-${PG_FEATURE}.tar.gz ./dist