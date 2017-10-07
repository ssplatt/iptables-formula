{%- from "iptables/map.jinja" import ipset with context %}
ipset_service_reload:
  cmd.run:
    - name: systemctl reload ipset
    - onchanges:
      - file: ipset_cfg_members
    - require:
      - service: ipset_service

ipset_service:
  service.{{ ipset.service.state }}:
    - name: ipset
    - enable: {{ ipset.service.enable }}
    - watch:
      - file: ipset_cfg_sets
    - require:
      - pkg: ipset_package
      - file: ipset_service_install
      - file: ipset_cfg_members
    - require_in:
      - service: iptables_service

ipset_stop_iptables:
  cmd.run:
    - name: systemctl stop iptables
    - onchanges:
      - file: ipset_cfg_sets
    - onlyif: systemctl status iptables
    - require_in:
      - service: ipset_service
