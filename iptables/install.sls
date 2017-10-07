# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "iptables/map.jinja" import iptables with context %}

iptables_packages:
  pkg.installed:
    - pkgs: {{ iptables.required_pkgs }}

iptables_start_script:
  file.managed:
    - name: /usr/local/bin/iptables-start.sh
    - source: salt://iptables/files/iptables-start.sh
    - user: root
    - group: root
    - mode: 0755
    - require:
      - pkg: iptables_packages

iptables_stop_script:
  file.managed:
    - name: /usr/local/bin/iptables-stop.sh
    - source: salt://iptables/files/iptables-stop.sh
    - user: root
    - group: root
    - mode: 0755
    - require:
      - file: iptables_start_script

iptables_service_install:
  file.managed:
    - name: /lib/systemd/system/iptables.service
    - source: salt://iptables/files/iptables.service
    - user: root
    - group: root
    - mode: 0644
    - require:
      - file: iptables_stop_script

iptables_notify_systemd_of_unit_changes:
  cmd.run:
    - name: 'systemctl daemon-reload'
    - onchanges:
      - file: iptables_service_install
