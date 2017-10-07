#!/bin/sh
# ipv4
/sbin/iptables -F
/sbin/iptables -X
/sbin/iptables -t nat -F
/sbin/iptables -t nat -X
/sbin/iptables -t mangle -F
/sbin/iptables -t mangle -X
/sbin/iptables -P INPUT ACCEPT
/sbin/iptables -P OUTPUT ACCEPT
/sbin/iptables -P FORWARD ACCEPT
# ipv6
/sbin/ip6tables -F
/sbin/ip6tables -X
/sbin/ip6tables -t nat -F
/sbin/ip6tables -t nat -X
/sbin/ip6tables -t mangle -F
/sbin/ip6tables -t mangle -X
/sbin/ip6tables -P INPUT ACCEPT
/sbin/ip6tables -P OUTPUT ACCEPT
/sbin/ip6tables -P FORWARD ACCEPT
