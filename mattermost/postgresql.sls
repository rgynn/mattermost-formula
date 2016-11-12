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

{% elif grains['os_family'] == 'Debian' %}

postgresql_packages:
  pkg.installed:
    - pkgs:
      - postgresql
      - postgresql-contrib

{% endif %}

/etc/postgresql/9.5/main/postgresql.conf:
  file.managed:
    - source: salt://mattermost/files/postgresql.conf
    - template: jinja
    - mode: 755
    - user: root
    - group: root

/etc/postgresql/9.5/main/pg_hba.conf:
  file.managed:
    - source: salt://mattermost/files/pg_hba.conf
    - template: jinja
    - mode: 755
    - user: root
    - group: root

postgresql:
  service.running:
    - enable: True
    - require:
      - pkg: postgresql_packages
    - watch:
      - file: /etc/postgresql/9.5/main/postgresql.conf
      - file: /etc/postgresql/9.5/main/pg_hba.conf

gogs_postgresql_db:
  postgres_user.present:
    - name: {{ postgresql['user'] }}
    - password: {{ postgresql['password'] }}
    - encrypted: True
  postgres_database.present:
    - name: {{ postgresql['database'] }}
    - owner: {{ postgresql['user'] }}