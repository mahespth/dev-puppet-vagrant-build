#!/bin/bash

echo "192.168.101.210 puppetmaster puppet" >>/etc/hosts

cd /tmp

yum -y update

rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

yum -y install puppet-agent

puppet agent --test --server puppetmaster


