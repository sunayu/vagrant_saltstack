Vagrant.configure("2") do |config|
  # Some vm settings

  # Major salt version to install
  salt_version = "3004"

  # This is the minions local subnet
  # Note this also needs to be changed in pillar/mine.sls
  net_ip = "192.168.56"
  
  # Number of minions to create not counting the saltmaster
  minion_count = 1

  # This is so we can use the same ssh key to make it easier to dev against
  # Yes it is insecure...
  config.ssh.insert_key = false

  # Which os to install
  os = "centos/7" # centos7
  #os = "ubuntu/xenial64" # ubuntu 16.04 LTS
  #os = "ubuntu/bionic64" # ubuntu 18.04 LTS
  #os = "ubuntu/focal64" # ubuntu 20.04 LTS

  # Move salt files to all systems to be run locally
  config.vm.provision "shell", inline: "chown vagrant /srv"
  config.vm.provision "file", source: "salt", destination: "/srv/salt"
  config.vm.provision "file", source: "pillar", destination: "/srv/pillar"

  config.vm.define "saltmaster", primary: true do |sm|
    sm.vm.box = "#{os}"
    sm.vm.host_name = 'saltmaster.vagrant.lan'
    sm.vm.network "private_network", ip: "#{net_ip}.10"

    # Change master hardware specs here
    config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end

    # We just use the salt provisioner to install and configure salt
    sm.vm.provision :salt do |salt|
      salt.install_master = true
      salt.verbose = true
      salt.colorize = true
      salt.install_type = "stable"
      salt.version = salt_version
      salt.bootstrap_options = "-X -c /tmp -A #{net_ip}.10 -i saltmaster -x python3"
    end

    # We call salt-call --local to configure the saltmaster
    sm.vm.provision "shell", inline: "salt-call --local state.apply setup_master"

  end

  # Setup our minions
  minion_count.times do |i|
    minion_index = i + 1

    config.vm.define "minion#{minion_index}" do |node|

      # Change minion hardware specs here
      config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 2
      end

      node.vm.box = "#{os}"
      node.vm.host_name = "minion#{minion_index}.vagrant.lan"
      node.vm.network "private_network", ip: "#{net_ip}.1#{minion_index}"

      # We just use the salt provisioner to install and configure salt
      node.vm.provision :salt do |salt|
        salt.install_master = false
        salt.verbose = true
        salt.colorize = true
        salt.install_type = "stable"
        salt.version = salt_version
        salt.bootstrap_options = "-X -c /tmp -A #{net_ip}.10 -i minion#{minion_index} -x python3"
      end

      # We call salt-call --local to configure each minion
      node.vm.provision "shell", inline: "salt-call --local state.apply setup_minion"

    end
  end
end
