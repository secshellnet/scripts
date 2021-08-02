# Secure Shell Networks: Scripts
Don't forget to adjust the execution time in the crontab.

### Database Backup
* Save [`docker_db_backup.sh`](./docker_db_backup.sh) as `/root/db_backup.sh`
* Create crontab:
  ```shell
  # run database backup
  0 */3 * * * /bin/bash /root/db_backup.sh >/dev/null 2>&1
  ```

### Borg Backup
* Save [`borg_backup.sh`](./borg_backup.sh) as `/root/backup.sh`
* Adjust configuration section of the script (borg passphrase + telegram token for reporting).
* Create crontab:
  ```shell
  # run borg backup
  0 4 * * * /bin/bash /root/backup.sh >/dev/null 2>&1
  ```

### Backup Exporter
* Save [`export_backup.sh`](./borg_backup.sh) as `/root/export_backup.sh`
* If you like to get alerts on failure:
  * Created `.telegram.sh` with a telegram api token
  * Adjust the chat_id in the curl requests.
* Create crontab:
  ```shell
  # export backup every ten days on 8pm
  0 20 */10 * * /bin/bash /root/export_backup.sh >/dev/null 2>&1
  ```

### Fix Permission
* Save [`fix_permission.sh`](./fix_permission.sh) as `/root/fix_permission.sh`
* Adjust the service configuration on the bottom of the script.
* Create crontab:
  ```shell
  # fix permissions
  0 0 * * * /bin/bash /root/fix-permission.sh >/dev/null 2>&1
  ```

### Pull Backup
* Save [`pull_backup.sh`](./pull_backup.sh) as `/root/pull_backup.sh` on a external server.
* Adjust the HOSTS array on the top of the script.
* Adjust the ip address of the host that should be pinged to make sure that the servers can be reached (defaults to 10.1.0.1)
* Create SSH key (ssh-keygen) and adjust config: `.ssh/config`:
  ```
  Host vm1.secshell.net
      Hostname 10.1.0.6
      User exporter
      IdentityFile ~/.ssh/backup_rsa
  ``` 
* Create crontab:
  ```shell
  # pull backups every ten days on 8pm
  0 20 */10 * * /bin/bash /root/pull_backup.sh >/dev/null 2>&1
  ```

