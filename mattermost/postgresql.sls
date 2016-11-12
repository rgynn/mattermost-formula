{% from "mattermost/map.jinja" import mattermost with context %}
{% set postgresql = mattermost.postgresql %}

{% if grains['os_family'] == 'RedHat' %}

postgresql_packages:
  pkg.installed:
    - pkgs:
      - postgresql-server
      - postgresql-contrib

setup_init_db:
  cmd.wait:
    - name: postgresql-setup initdb
    - watch:
      - pkg: postgresql_packages

postgres_config:
  file.managed:
    - name: /var/lib/pgsql/data/postgresql.conf
    - source: salt://mattermost/files/postgresql.conf.centos
    - template: jinja
    - mode: 755
    - user: root
    - group: root

postgres_hba_config:
  file.managed:
    - name: /var/lib/pgsql/data/pg_hba.conf
    - source: salt://mattermost/files/pg_hba.conf
    - template: jinja
    - mode: 755
    - user: root
    - group: root

{% elif grains['os_family'] == 'Debian' %}

postgresql_packages:
  pkg.installed:
    - pkgs:
      - postgresql
      - postgresql-contrib

postgres_config:
  file.managed:
    - name: /etc/postgresql/9.5/main/postgresql.conf
    - source: salt://mattermost/files/postgresql.conf
    - template: jinja
    - mode: 755
    - user: root
    - group: root

postgres_hba_config:
  file.managed:
    - name: /etc/postgresql/9.5/main/pg_hba.conf
    - source: salt://mattermost/files/pg_hba.conf
    - template: jinja
    - mode: 755
    - user: root
    - group: root

{% endif %}

postgresql:
  service.running:
    - enable: True
    - require:
      - pkg: postgresql_packages
    - watch:
      - file: postgres_config
      - file: postgres_hba_config

gogs_postgresql_db:
  postgres_user.present:
    - name: {{ postgresql['user'] }}
    - password: {{ postgresql['password'] }}
    - encrypted: True
  postgres_database.present:
    - name: {{ postgresql['database'] }}
    - owner: {{ postgresql['user'] }}