#!/bin/bash

cd /tmp

case $( uname -n ) in
	*master*)
		yum -y update

		#http://yum.puppetlabs.com/
		rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm

		yum -y install puppetserver
		;;
	*)
		echo "192.168.101.210 puppetmaster puppet" >>/etc/hosts

		if [[ -e /etc/redhat-release ]]
		then

			yum -y update

			rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

			yum -y install puppet-agent

			# can take a while before server is up - we should run a loop until port is available
			sleep 300
			puppet agent --test --server puppetmaster
		else
			apt-get -y update
			apt-get -y install wget

			wget -q http://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb

			sudo dpkg -i puppetlabs-release-pc1-xenial.deb 

			apt-get -y install puppet-agent

			sleep 300
			puppet agent --test --server puppetmaster
		fi
	;;
esac

