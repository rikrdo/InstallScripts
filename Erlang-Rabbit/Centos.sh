#!/bin/bash

echo '************************YUM UPDATE'
yum update -y
echo '************************YUM INSTALL epel-release'
yum install -y epel-release 
echo '************************YUM INSTALL gcc gcc-c++ glibc-devel make ncurses-devel openssl-devel autoconf java-1.8.0-openjdk-devel git wget wxBase.x86_64'
yum install -y gcc gcc-c++ glibc-devel make ncurses-devel openssl-devel autoconf java-1.8.0-openjdk-devel git wget wxBase.x86_64
echo '************************WGET http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm'
wget http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
echo '************************RPM erlang-solutions-1.0-1.noarch.rpm'
rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
echo '************************YUM UPDATE'
yum update -y
echo '************************YUM INSTALL yum-plugin-versionlock'
yum install -y yum-plugin-versionlock; yum clean all
echo '************************YUM INSTALL versionlock erlang-20.3.8.18-1.el7'
yum versionlock erlang-20.3.8.18-1.el7
echo '************************YUM INSTALL erlang-20.3.8.18-1.el7'
yum install -y erlang-20.3.8.18-1.el7

echo '************************RPM https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc'
rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc

echo '************************CREATE FILE /etc/yum.repos.d/rabbitmq.repo'
printf "[bintray-rabbitmq-server]\nname=bintray-rabbitmq-rpm\nbaseurl=https://dl.bintray.com/rabbitmq/rpm/rabbitmq-server/v3.7.x/el/7/\ngpgcheck=0\nrepo_gpgcheck=0\nenabled=1\n" > /etc/yum.repos.d/rabbitmq.repo

echo '************************RPM https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc'
rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc

echo '************************YUM INSTALL rabbitmq-server-3.7.6-1.el7'
yum install -y rabbitmq-server-3.7.6-1.el7

echo '************************RABBITMQ enable rabbitmq-server.service'
systemctl enable rabbitmq-server.service

echo '************************RABBITMQ enable rabbitmq_management'
rabbitmq-plugins enable rabbitmq_management

echo '************************CREATE FILE /etc/rabbitmq/rabbitmq.conf'
printf "listeners.tcp.1 = :::5672\nloopback_users = none\nmanagement.listener.port = 15672\nmanagement.listener.ip   = 0.0.0.0\n" > /etc/rabbitmq/rabbitmq.conf

echo '************************OPEN FIREWALL 15672'
firewall-cmd --zone=public --permanent --add-port=15672/tcp

echo '************************OPEN FIREWALL 5672'
firewall-cmd --zone=public --permanent --add-port=5672/tcp

echo '************************RELOAD FIREWALL'
firewall-cmd --reload

echo '************************START RabbitMQ'
chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
/sbin/service rabbitmq-server start

echo '************************YUM INSTALL erlang-rebar'
yum install -y erlang-rebar


