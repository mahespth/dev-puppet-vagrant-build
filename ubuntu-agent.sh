#!/bin/bash

echo "192.168.101.210 puppetmaster puppet" >>/etc/hosts

cd /tmp

wget http://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
sudo dpkg -i puppetlabs-release-pc1-xenial.deb 

apt-get -y update

apt-get -y install puppet-agent

puppet agent --test --server puppetmaster


