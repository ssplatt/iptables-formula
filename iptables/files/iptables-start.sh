#!/bin/sh
/sbin/iptables-restore < /etc/iptables/rules.v4
/sbin/ip6tables-restore < /etc/iptables/rules.v6
