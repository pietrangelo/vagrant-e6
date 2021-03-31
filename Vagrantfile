# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-20.04"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine.
  # Expose port 8443 from openshift to port 8043 of your host
   config.vm.network "forwarded_port", guest: 8443, host: 8043
  # Espose port 80 from openshift to port 8080 of your host
   config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
   config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
   config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     vb.gui = true

     # Customize the amount of memory on the VM:
     #vb.memory = "8192" # 8GB
     #vb.memory = "6144" # 6GB
     vb.memory = "4096" # 4GB
     # Customize the cpus
     vb.cpus = 4
   end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
   config.vm.provision "shell", inline: <<-SHELL
     apt-get update
     apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common net-tools
     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
     add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
     apt-get update
     apt-get install -y docker-ce docker-ce-cli containerd.io
     service docker start
     usermod -aG docker vagrant
     # Configure docker for openshift
     service docker stop
     docker_config_file="/etc/docker/daemon.json"
     touch ${docker_config_file}
     echo "{" > ${docker_config_file}
     echo '"insecure-registries": ["172.30.0.0/16"],' >> ${docker_config_file}
     echo '"default-address-pools": [{"base": "10.222.0.0/16", "size": 24}],' >> ${docker_config_file}
     echo '"dns": ["8.8.8.8", "1.1.1.1"]' >> ${docker_config_file}
     echo "}" >> ${docker_config_file}
     # Restart docker service
     service docker start
     # Download and install Openshift client tools
     pushd /tmp
     wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
     tar xvfz openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
     cd openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit
     mv oc /usr/local/bin
     mv kubectl /usr/local/bin
     popd
     # install resolvconf package to fix dns issues
     apt-get -y install resolvconf
     rm -f /etc/resolv.conf
     touch /etc/resolv.conf
     echo "nameserver 8.8.8.8" > /etc/resolv.conf
     echo "nameserver 1.1.1.1" >> /etc/resolv.conf
     chattr +i /etc/resolvconf/resolv.conf
     service resolvconf restart
   SHELL
   # Copy bash script to /home/vagrant
   config.vm.provision "file", source: "start-oc.sh", destination: "start-oc.sh"
   # Set execute permission to file
   config.vm.provision "shell", inline: "chmod +x /home/vagrant/start-oc.sh"
end
