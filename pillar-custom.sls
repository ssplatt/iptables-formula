ipset:
  enabled: True
  service:
    state: running
    enable: false
  sets:
    loopback:
        type: hash:ip
        members:
          - 127.0.0.1
          - 127.0.0.2
    my-link-local-blocks:
      type: hash:net
      family: inet6
      members:
        - fe80::/64
        - fe80:1::/64
        - fe80:2::/64
        - fe80:3::/64
iptables:
  enabled: True
  service:
    name: iptables
    state: running
    enable: True
  icmp_v4_echo_request: disable
  filter:
    rules:
      - dport: 8080
        proto: tcp
        source: loopback
        jump: DROP
      - dport: ssh
        proto: tcp
        source: 172.16.254.0/24
        dest: 192.168.1.1
        jump: REJECT
        rejectwith: icmp-host-prohibited
        comment: "SSH Access"
      - dport: ssh
        state: NEW
      - dport: http
      - dport: https
        sources:
          - 10.0.0.0/8
          - 172.16.0.0/12
          - 192.168.0.0/16
      - dport: snmp
        proto: udp
      - dport: 9200
      - dport: 9300
      - dport: 6379
      - dport: 5140
        proto: tcp
      - dport: 5140
        proto: udp
      - dport: 5601
      - source: 10.0.0.0/8
      - source: 172.16.0.0/12
      - source: 192.168.0.0/16
      - match: limit
        limit: 5/min
        jump: LOG
        log_prefix: "iptables denied: "
        log_level: 7
    rules_v6:
      - source: my-link-local-blocks
        jump: ACCEPT
      - dport: ssh
        state: NEW
      - dport: http
      - dport: https
      - match: limit
        limit: 5/min
        jump: LOG
        log_prefix: "iptables denied: "
        log_level: 7
