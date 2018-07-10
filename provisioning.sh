#!/bin/bash

cd /tmp


export PATH=$PATH:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin

case $( uname -n ) in
	*master*)
		puppet cert list | awk '{ print $1 }'
		if ! rpm -qa | grep -q puppetserver
		then
			cat <<-EOF >/etc/profile.d/puppet-agent.sh
			# Add /opt/puppetlabs/bin to the path for sh compatible users
		
			if ! echo \$PATH | grep -q /opt/puppetlabs/bin ; then
			 export PATH=\$PATH:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin
			fi
			EOF

			yum -y update
			rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
			yum -y install puppetserver
	
			# PE requirements for the WS !?
			#yum install -y httpd httpd-devel mod_ssl ruby-devel rubygems gcc-c++ curl-devel zlib-devel make automake  openssl-devel
			#gem install rack passenger
			gem install puppet-lint
			# ( puppet-line site.pp )
				

			# Modify this if you'd like to change the memory allocation, enable JMX, etc
			JAVA_ARGS="-Xms2g -Xmx2g " #-XX:MaxPermSize=256m"
			sed -i "s/-XX:MaxPermSize=256m//" /etc/sysconfig/puppetserver 
			sed -i "s/-Xms2g -Xmx2g/-Xms1g -Xmx1g/" /etc/sysconfig/puppetserver 

			systemctl start puppetserver 
			journalctl -xe 
		fi

		true

		puppet cert list | grep ubuntu && puppet cert sign ubuntu-agent
		puppet cert list | grep centos && puppet cert sign centos-agent

		cd / ; tar   --no-same-owner -xvf /vagrant/puppet.tar

		puppet module list
		;;
	*)
		if ! grep -q puppetmaster /etc/hosts
		then
			echo '* Adding puppet master to /etc/hosts'
			echo "192.168.101.220 puppetmaster puppet" >>/etc/hosts
		fi

		if [[ -e /etc/redhat-release ]]
		then


			yum -y update
			rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

			yum -y install puppet-agent

		else
			apt-get -y update
			apt-get -y install wget

			rm -f puppetlabs*.deb
			wget -q http://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb

			dpkg -i puppetlabs-release-pc1-xenial.deb \
			&& apt-get -y update

			apt-get -y install puppet-agent

		fi

		echo 'testing puppet agent"'
		puppet agent --test --server puppetmaster --noop
		#puppet agent -t -d


		echo "unpacking puppet.tar"
		tar --no-same-owner -xvf puppet.tar

		true
	;;
esac

