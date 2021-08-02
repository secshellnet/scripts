#!/bin/bash

declare -A HOSTS=(
  ['exporter@vm1.secshell.net:']="/home/exporter/vm1.secshell.net"
  ['exporter@lxc.secshell.net:']="/home/exporter/lxc.secshell.net"
)

# load telegram api token
. /root/.telegram.sh

# check if morpheus network is reachable
if [[ -z $(ping -c1 -w1 10.1.0.1) ]]; then
  /usr/bin/curl -X POST \
    -H 'Content-Type: application/json' \
    -d  '{"chat_id": "239086941", "text": "'$(hostname -f)': Offside backup failed, network unreachable!", "disable_notification": true}' \
    https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage >/dev/null 2>&1
  exit
fi

trap 'on_error' ERR
function on_error {
  /usr/bin/curl -X POST \
    -H 'Content-Type: application/json' \
    -d  '{"chat_id": "239086941", "text": "'$(hostname -f)': '${LOCAL_PATH##*/}' Offside Backup failed!", "disable_notification": true}' \
    https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage >/dev/null 2>&1
}

# update last_run.txt
/bin/date +"%Y-%m-%d %H-%M-%S" > /home/exporter/last_run.txt

# loop through hosts
for SFTP_ARGS in ${!HOSTS[@]}; do
  LOCAL_PATH=${HOSTS[${SFTP_ARGS}]}
  mkdir -p ${LOCAL_PATH}

  /usr/bin/sftp ${SFTP_ARGS}/backup_repository.tar ${LOCAL_PATH}/backup_repository.tar
  /usr/bin/sftp ${SFTP_ARGS}/backup_repository.md5sum.txt ${LOCAL_PATH}/backup_repository.md5sum.txt

  # recreate checksum files (keep checksum)
  checksum=$(cat ${LOCAL_PATH}/backup_repository.md5sum.txt | cut -d " " -f1)
  echo "${checksum}  ${LOCAL_PATH}/backup_repository.tar" > ${LOCAL_PATH}/backup_repository.md5sum.txt
  /usr/bin/md5sum -c ${LOCAL_PATH}/backup_repository.md5sum.txt
done
