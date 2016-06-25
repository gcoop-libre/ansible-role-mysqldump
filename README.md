# Ansible Role: gcoop.mysqldump

This role, configure access to MySQL/MariaDB/Percona in localhost and cronfile for backup using `mysqldump` command.

## Requirements

* python-mysqldb
* MySQL/MariaDB/Percona

## Optional

[Ansible Pass Lookup Plugin](https://github.com/gcoop-libre/ansible-lookup-plugin-pass) allows you to use a use a [pass](https://www.passwordstore.org/) compatible password store to generate encrypted passwords. It mimics de behaviour of the password lookup, but using `pass` instead of plaintext files for storing the passwords.

## Role Variables

Available variables with default values (see `defaults/main.yml`).

```yaml

gcoop_mysqldump_cron_entries:

  - name: monthly
    minute: 0
    hour: 2
    day: '*/7'
    format: '%b'
    database: "{{ gcoop_mysqldump_database }}"

  - name: daily
    minute: 0
    hour: 1
    day: '*'
    format: '%a'
    database: "{{ gcoop_mysqldump_database }}"

  - name: hourly
    minute: 30
    hour: '*'
    day: '*'
    format: ''
    database: 'mysql'
```

The default `gcoop_mysqldump_cron_entries` generate following files in ``/backup/sql`` directory:

One file per weekday:

```
    hostname-dbname1-lun.sql.gz
    hostname-dbname1-mar.sql.gz
    hostname-dbname1-mie.sql.gz
    hostname-dbname1-jue.sql.gz
    hostname-dbname1-vie.sql.gz
    hostname-dbname1-sab.sql.gz
    hostname-dbname1-dom.sql.gz
    hostname-dbname2-lun.sql.gz
    hostname-dbname2-mar.sql.gz
    hostname-dbname2-mie.sql.gz
    hostname-dbname2-jue.sql.gz
    hostname-dbname2-vie.sql.gz
    hostname-dbname2-sab.sql.gz
    hostname-dbname2-dom.sql.gz
```

One file per month (update every 7 days):

```
    hostname-dbname1-ene.sql.gz
    hostname-dbname1-feb.sql.gz
    ...
    hostname-dbname1-dic.sql.gz
    hostname-dbname2-ene.sql.gz
    ...
    hostname-dbname2-feb.sql.gz
    hostname-dbname2-dic.sql.gz
```

One file updated with the latest dump (update every 1 hour)

```
    hostname-dbname1.sql.gz
    hostname-dbname2.sql.gz
```

## Syslog

By default, role log cronjob to syslog:

```
root@dbserver:/backup/sql# tail -f /var/log/syslog

Jun 25 02:30:02 dbserver mysqldump: Start: 2016-06-25 02:30 End: 2016-06-25 02:30 Duration: 00:00:01 File: c2340030bd3ec4c5b890a7e7ae80fd18  /backup/sql/dbserver-mysql.sql.gz
Jun 25 02:30:02 dbserver mysqldump: Start: 2016-06-25 02:30 End: 2016-06-25 02:30 Duration: 00:00:00 File: 5b5f36528df547e08f42db615e22ded6  /backup/sql/dbserver-information_schema-jun.sql.gz
Jun 25 02:30:02 dbserver mysqldump: Start: 2016-06-25 02:30 End: 2016-06-25 02:30 Duration: 00:00:00 File: 6d952bdd7edf0e5663bbd487dbcaf46c  /backup/sql/dbserver-mysql-jun.sql.gz
```

## Dependencies

None.

## Example Playbook

If you want to create a new system and mysql user using lookup pass plugin:

```yaml
    - hosts: localhost
      become: yes
      remote_user: debian

      roles:
        - role: gcoop.mysqldump
          gcoop_mysqldump_create_mysql_user: yes
          gcoop_mysqldump_create_system_user: yes
          gcoop_mysqldump_mysql_username: mysqlbackup
          gcoop_mysqldump_mysql_password: "{{ lookup( 'pass', 'mysql/' + gcoop_mysqldump_mysql_username ) }}"
          gcoop_mysqldump_mysql_root_password: "{{ lookup( 'pass', 'mysql/root' ) }}"
          gcoop_mysqldump_system_password:     "{{ lookup( 'pass', 'users/' + gcoop_mysqldump_mysql_username ) }}"
```

When you already have a system and mysql user:

```yaml
    - hosts: localhost
      become: yes
      remote_user: debian

      roles:
        - role: gcoop.mysqldump
          gcoop_mysqldump_mysql_username: mark
          gcoop_mysqldump_mysql_password: dadada
          gcoop_mysqldump_mysql_root_password: 123456
```

## License

GNU General Public License, GPLv3.

## Author Information

This role was created in 2016 by [Osiris Alejandro Gomez](http://osiux.com/), worker cooperative of [gcoop Cooperativa de Software Libre](http://www.gcoop.coop/).

