# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
	config.vm.provider "virtualbox" do |v|
		v.customize ["modifyvm", :id, "--audio", "none"]
		v.gui = false
		v.memory = 2048
		v.cpus = "2"
	end

	config.vm.define "puppetmaster" do |pm|
		pm.vm.box = "centos/7"
		pm.vm.network "public_network", ip: "192.168.101.220", bridge: "enp7s0"
		pm.vm.hostname = "puppetmaster"
	end

	config.vm.define "puppet-agent-ubuntu" do |pau|
		pau.vm.box = "ubuntu/xenial64"
		pau.vm.network "public_network", ip: "192.168.101.222", bridge: "enp7s0"
		pau.vm.hostname = "ubuntu-agent"
	end

	config.vm.define "puppet-agent-centos" do |pac|
		pac.vm.box = "centos/7"
		pac.vm.network "public_network", ip: "192.168.101.221", bridge: "enp7s0"
		pac.vm.hostname = "centos-agent"
	end

	config.vm.provision "shell", path: "provisioning.sh"
end
