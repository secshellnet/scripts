#!/bin/bash

ADM_HOME="/home/admin"
BACKUP_DIR="/home/backups"
EXPORTER_HOME="/home/exporter"

# require root privileges
if [[ $(/usr/bin/id -u) != "0" ]]; then
  echo "Please run the script as root!"
  exit 1
fi

# admin directory
chown -R root:admin ${ADM_HOME}
find ${ADM_HOME} -type d -exec chmod 0775 {} \;
find ${ADM_HOME} -type f -exec chmod 0664 {} \;
find ${ADM_HOME}/tools/ -type f -exec chmod 0775 {} \;

# passphrases and tokens
chown root:root /root/.{borg,telegram}.sh
chmod 600 /root/.{borg,telegram}.sh

# backup directory
chmod -R 750 ${BACKUP_DIR}
chown -R root:admin ${BACKUP_DIR}

# exporter directory (sftp)
chown -R root:root ${EXPORTER_HOME}
find ${EXPORTER_HOME} -type d -exec chmod 0755 {} \;

# services
#chown -R 472:472 /srv/main/grafana
#chown -R 1500:1500 /srv/main/hackmd
#chown -R 911:911 /srv/main/bookstack
#chown -R 5050:5050 /srv/main/pgadmin
#find /srv/main/pgadmin/storage -type f -exec chmod 0600 {} \;
