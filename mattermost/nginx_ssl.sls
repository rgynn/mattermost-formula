{% if grains['os_family'] == 'RedHat' %}

pyOpenSSL:
  pkg.installed

{% elif grains['os_family'] == 'Debian' %}

python-deps:
  pkg.installed:
    - pkgs:
      - python-pip
      - libssl-dev

pyOpenSSL:
  pip.installed

{% endif %}

self_signed_cert:
  module.run:
    - name: tls.create_self_signed_cert
    
    {% if grains['os_family'] == 'Debian' %}

    - require:
      - pkg: python-deps
      - pip: pyOpenSSL
    - watch:
      - pip: pyOpenSSL
    
    {% elif grains['os_family'] == 'RedHat' %}
    
    - require:
      - pkg: pyOpenSSL
    - watch:
      - pkg: pyOpenSSL
    
    {% endif %}