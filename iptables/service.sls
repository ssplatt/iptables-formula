# -*- coding: utf-8 -*-
# vim: ft=sls
# Manage service for service iptables
{%- from "iptables/map.jinja" import iptables with context %}

iptables_service:
  service.{{ iptables.service.state }}:
    - name: {{ iptables.service.name }}
    - enable: {{ iptables.service.enable }}
    - watch:
      - file: iptables_v4_config
      - file: iptables_v6_config
    - require:
      - pkg: iptables_packages
      - file: iptables_service_install
      - file: iptables_start_script
      - file: iptables_stop_script
