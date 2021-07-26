#!/bin/bash

BACKUP_DIR="/home/backups/"

docker run --rm \
  -e "POSTGRES_HOST=main_postgres_1" \
  -e "POSTGRES_DATABASES=" \
  -e "POSTGRES_USERNAME=" \
  -e "POSTGRES_PASSWORD=" \
  -v "${BACKUP_DIR}:/data/" \
  --network=database \
  ghcr.io/felbinger/dbm

# adjust permissions of the created backup
chown -R root:admin ${BACKUP_DIR}
find ${BACKUP_DIR} -type d -exec chmod 0750 {} \;
find ${BACKUP_DIR} -type f -exec chmod 0640 {} \;
