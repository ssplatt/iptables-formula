# -*- coding: utf-8 -*-
# vim: ft=sls
# Init iptables
{%- from "iptables/map.jinja" import iptables with context %}
{%- from "iptables/map.jinja" import ipset with context %}

{%- if iptables.enabled %}
include:
{%- if ipset.enabled %}
  - iptables.ipset 
{%- endif %}
  - iptables.install
  - iptables.config
  - iptables.service
{%- else %}
'iptables-formula disabled':
  test.succeed_without_changes
{%- endif %}
