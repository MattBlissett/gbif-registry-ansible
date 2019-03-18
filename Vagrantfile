VAGRANTFILE_API_VERSION = "2"

##
# A script to bring up an Ubuntu 16 server with the GBIF Registry.
##
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.ssh.insert_key = false
  config.vm.box = "ubuntu/xenial64"

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
  end

  config.vm.provision :shell, :inline => "sed -i 's/\\/\\/.*archive.ubuntu.com/\\/\\/dk.archive.ubuntu.com/g' /etc/apt/sources.list"

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "provisioning/playbook.yml"
  end

  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 80, host: 8090
  config.vm.network "forwarded_port", guest: 5672, host: 5672
  config.vm.network "forwarded_port", guest: 15672, host: 15672
end
