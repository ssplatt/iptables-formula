require 'serverspec'

# Required by serverspec
set :backend, :exec

describe package('iptables') do
  it { should be_installed }
end

describe package('iptables-persistent') do
  it { should be_installed }
end

describe file('/etc/iptables/rules.v4') do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /^-A INPUT -s 172.16.254.0\/24 -d 192.168.1.1 -p tcp -m tcp --dport ssh -m comment --comment "SSH Access" -j REJECT --reject-with icmp-host-prohibited/ }
  its(:content) { should match /^-A INPUT -p tcp -m state --state NEW --dport ssh -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -p tcp -m tcp --dport http -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -s 10.0.0.0\/8,172.16.0.0\/12,192.168.0.0\/16 -p tcp -m tcp --dport https -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -p udp -m udp --dport snmp -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -p tcp -m tcp --dport 9200 -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -p tcp -m tcp --dport 9300 -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -p tcp -m tcp --dport 6379 -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -p tcp -m tcp --dport 5140 -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -p udp -m udp --dport 5140 -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -p tcp -m tcp --dport 5601 -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -s 10.0.0.0\/8 -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -s 172.16.0.0\/12 -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -s 192.168.0.0\/16 -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -m limit --limit 5\/min -j LOG --log-prefix "iptables denied: " --log-level 7/ }
  its(:content) { should_not match /^-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT/ }
end

describe command('iptables -S') do
  its(:stdout) { should match /^-P INPUT ACCEPT/ }
  its(:stdout) { should match /^-P FORWARD ACCEPT/ }
  its(:stdout) { should match /^-P OUTPUT ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -s 172.16.254.0\/24 -d 192.168.1.1\/32 -p tcp -m tcp --dport 22 -m comment --comment "SSH Access" -j REJECT --reject-with icmp-host-prohibited/ }
  its(:stdout) { should match /^-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -s 10.0.0.0\/8 -p tcp -m tcp --dport 443 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -s 172.16.0.0\/12 -p tcp -m tcp --dport 443 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -s 192.168.0.0\/16 -p tcp -m tcp --dport 443 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -p udp -m udp --dport 161 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -p tcp -m tcp --dport 9200 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -p tcp -m tcp --dport 9300 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -p tcp -m tcp --dport 6379 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -p tcp -m tcp --dport 5140 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -p udp -m udp --dport 5140 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -p tcp -m tcp --dport 5601 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -s 10.0.0.0\/8 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -s 172.16.0.0\/12 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -s 192.168.0.0\/16 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -m limit --limit 5\/min -j LOG --log-prefix "iptables denied: " --log-level 7/ }
  its(:stdout) { should_not match /^-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -p tcp -m set --match-set loopback src -m tcp --dport 8080 -j DROP/ }
end

describe file('/etc/iptables/rules.v6') do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) { should match /^-A INPUT -p tcp -m state --state NEW --dport ssh -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -p tcp -m tcp --dport http -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -p tcp -m tcp --dport https -j ACCEPT/ }
  its(:content) { should match /^-A INPUT -m limit --limit 5\/min -j LOG --log-prefix "iptables denied: " --log-level 7/ }
end

describe command('ip6tables -S') do
  its(:stdout) { should match /^-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -p tcp -m tcp --dport 443 -j ACCEPT/ }
  its(:stdout) { should match /^-A INPUT -m limit --limit 5\/min -j LOG --log-prefix "iptables denied: " --log-level 7/ }
  its(:stdout) { should match /^-A INPUT -m set --match-set my-link-local-blocks src -j ACCEPT/ }
end

describe command('ipset save') do
  its(:stdout) { should match /^create loopback hash:ip family inet hashsize 1024 maxelem 65536/ }
  its(:stdout) { should match /^add loopback 127.0.0.1/ }
  its(:stdout) { should match /^add loopback 127.0.0.2/ }
  its(:stdout) { should match /^create my-link-local-blocks hash:net family inet6 hashsize 1024 maxelem 65536/ }
  its(:stdout) { should match /^add my-link-local-blocks fe80::\/64/ }
  its(:stdout) { should match /^add my-link-local-blocks fe80:1::\/64/ }
  its(:stdout) { should match /^add my-link-local-blocks fe80:2::\/64/ }
  its(:stdout) { should match /^add my-link-local-blocks fe80:3::\/64/ }
end

describe file('/lib/systemd/system/iptables.service') do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/usr/local/bin/iptables-start.sh') do
  it { should exist }
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/usr/local/bin/iptables-stop.sh') do
  it { should exist }
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe service('iptables') do
  it { should be_enabled }
  it { should be_running.under('systemd') }
end
