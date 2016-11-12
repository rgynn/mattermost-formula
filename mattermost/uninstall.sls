{% from "mattermost/map.jinja" import mattermost with context %}
{% set config = mattermost.config %}

mattermost_dir:
  file.absent:
    - name: {{ config['install_dir'] }}

log_dir:
  file.absent:
    - name: {{ config['log_dir'] }}

/etc/systemd/system/mattermost.service:
  file.absent