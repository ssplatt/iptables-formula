{%- from "iptables/map.jinja" import ipset with context %}
ipset_package:
  pkg.installed:
    - name: {{ ipset.pkg }}

ipset_service_install:
  file.managed:
    - name: /etc/systemd/system/{{ ipset.service.name }}.service
    - source: salt://iptables/files/ipset.service
    - user: root
    - group: root
    - mode: 0600
