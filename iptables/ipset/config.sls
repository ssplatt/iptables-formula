{%- from "iptables/map.jinja" import ipset with context %}
ipset_cfg_dir:
  file.directory:
    - name: /usr/local/etc/ipset
    - user: root
    - group: root
    - mode: 0700

ipset_cfg_sets:
  file.managed:
    - name: /usr/local/etc/ipset/sets.conf
    - source: salt://iptables/files/ipset-sets.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - sets: {{ ipset.sets }}
    - require:
      - file: ipset_cfg_dir

ipset_cfg_members:
  file.managed:
    - name: /usr/local/etc/ipset/members.conf
    - source: salt://iptables/files/ipset-members.conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - sets: {{ ipset.sets }}
    - require:
      - file: ipset_cfg_dir
