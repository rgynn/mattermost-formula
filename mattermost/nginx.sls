/etc/nginx/conf.d/mattermost.conf:
  file.managed:
    - source: salt://mattermost/files/nginx-vhost.conf
    - template: jinja
    - makedirs: True
    - require:
      - pkg: nginx

nginx:
  pkg.installed: []
  service.running:
    - service: nginx
    - require:
      - pkg: nginx
      - file: /etc/nginx/conf.d/mattermost.conf
    - watch:
      - file: /etc/nginx/conf.d/mattermost.conf