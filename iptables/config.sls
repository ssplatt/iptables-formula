# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "iptables/map.jinja" import iptables with context %}

iptables_v4_config:
  file.managed:
    - name: /etc/iptables/rules.v4
    - source: salt://iptables/files/rules.v4.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

iptables_v6_config:
  file.managed:
    - name: /etc/iptables/rules.v6
    - source: salt://iptables/files/rules.v6.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0644
