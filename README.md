#iptables-formula

This module manages your firewall using iptables with pillar configured rules.
Thanks to the nature of Pillars it is possible to write global and local settings (e.g. enable globally, configure locally).

By default, you will get locked out of the server, completely. you must specify any services (like ssh) explicitly to allow access.

##Usage

All the configuration for the firewall is done via pillar (pillar.example).

enable:
```
iptables:
  enabled: True
  service:
    name: iptables
    state: running
    enable: True
```

###Services
defaults to `-A INPUT -p tcp --dport <foo> -j ACCEPT` when dport is specified. To reject, specify `jump: REJECT`. You can specify one protocol with `proto` or several protocols in a list using `protos`. Same with `dest/dests` and `source/sources`. `dport` can be a service name if it is a standard port, i.e. ssh, http, https, or a port number.
```
iptables:
  enabled: True
  filter:
    rules:
      - dport: http
        source: 172.16.254.0/24
        dest: 192.168.1.1
        jump: REJECT
        rejectwith: icmp-host-prohibited
      - dport: ssh
        match: state
        state: NEW
        proto: tcp
        interface: eth0
    rules_v6:
      - dport: ssh
        match: state
        state: NEW
        proto: tcp
        interface: eth0
```

###Whitelists
```
iptables:
  enabled: True
  filter:
    rules:
      - source: 10.0.0.0/8
      - source: 172.16.0.0/12
      - source: 192.168.0.0/16
```

###NAT
```
iptables:
  enabled: True
  nat:
    rules:
      - oface: eth0
        source: 192.168.18.0/24
        dest: 10.20.0.2
      - oface: eth0
        source: 192.168.18.0/24
        dests:
          - 172.31.0.2
          - 10.0.0.0/8
```

### IPSet Support ###

Groups of IP addresses may be maintained as an ipset instead of as a series of individual rules for ease of management. IPSets may be specified as lists of address values.

Once a set is declared, the set name may be used in place of a "source" or "dest" value when specifying firewall rules.

#### IPSets from lists ####

```
iptables:
  enabled: true
  with_sets:
    enabled: true
  service:
    name: iptables
    state: running
    enable: true
  sets:
    my-set-name:
      type: hash:ip  # see ipset(8) for valid set types
      members:
        - 192.168.1.1
        - 192.168.1.2
    my-v6set-name:
      type: hash:net
      family: inet6
      members:
        - fe80::/64
        - fe80:1::/64
  filter:
    rules:
      - source: my-set-name
        jump: ACCEPT
    rules_v6:
      - source: my-v6set-name
        jump: ACCEPT

###Disable ICMP v4 Echo Requests
There may be a desire to disable icmp echo requests (ping) to prevent scanning of sensitve systems. The pillar value `icmp_v4_echo_request: disable` will prevent echo requests. The default value will allow pings. **This only effects ipv4** ipv6 rules are not effected.
```
iptables:
  enabled: True
  icmp_v4_echo_request: disable
  filter:
    rules:
      - dport: ssh
```
