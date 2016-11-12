{% from "mattermost/map.jinja" import mattermost with context %}
{% set config = mattermost.config %}

mattermost_archive:
  archive.extracted:
    - name: {{ config['extract_archive_dir'] }}
    - source: https://releases.mattermost.com/{{ config['version'] }}/mattermost-{{ config['version'] }}-linux-amd64.tar.gz
    - source_hash: {{ config['hash_type'] }}={{ config['hash'] }}
    - archive_format: tar
    - user: {{ config['run_user'] }}
    - group: {{ config['run_user'] }}
    - if_missing: {{ config['install_dir'] }}/bin/platform
    - require:
      - user: mattermost

data_dir:
  file.directory:
    - name: {{ config['data_dir'] }}
    - user: {{ config['run_user'] }}
    - group: {{ config['run_user'] }}
    - mode: 755
    - recurse:
      - user
      - group
      - mode
    - require:
      - user: mattermost

log_dir:
  file.directory:
    - name: {{ config['log_dir'] }}
    - user: {{ config['run_user'] }}
    - group: {{ config['run_user'] }}
    - mode: 755
    - recurse:
      - user
      - group
      - mode
    - require:
      - user: mattermost

config_file:
  file.managed:
    - name: {{ config['install_dir'] }}/config/config.json
    - source: salt://mattermost/files/config.json
    - user: {{ config['run_user'] }}
    - group: {{ config['run_user'] }}
    - mode: 755
    - template: jinja
    - require:
      - user: mattermost

english_translation_file:
  file.managed:
    - name: {{ config['install_dir'] }}/i18n/en.json
    - source: salt://mattermost/files/en.json
    - user: {{ config['run_user'] }}
    - group: {{ config['run_user'] }}
    - mode: 755
    - require:
      - user: mattermost

/etc/systemd/system/mattermost.service:
  file.managed:
    - source: salt://mattermost/files/mattermost.service
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - require:
      - archive: mattermost_archive


mattermost:
  user.present:
    - home: {{ config['install_dir'] }}
  service.running:
    - enable: True
    - requires:
      - user: mattermost
      - archive: mattermost_archive
      - file: config_file
      - file: log_dir
    - watch:
      - file: config_file
      - archive: mattermost_archive