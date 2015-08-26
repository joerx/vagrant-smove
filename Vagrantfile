# -*- mode: ruby -*-
# vi: set ft=ruby :

# Don't change unless you know what you are doing.
Vagrant.configure(2) do |config|

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "vivid64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/vivid/current/vivid-server-cloudimg-amd64-vagrant-disk1.box"

  # Port mappings. Use alternate ports to avoid collisions
  config.vm.network "forwarded_port", guest: 1337, host: 1338 # Sails
  config.vm.network "forwarded_port", guest: 80, host: 8080 # Apache
  config.vm.network "forwarded_port", guest: 3306, host: 3307 # MySQL

  # Host-only network, useful for testing things like deployment
  config.vm.network "private_network", ip: "192.168.33.10"

  # Share parent folder, assuming it contains the project sources
  config.vm.synced_folder "../", "/src", id: "smove", owner: "vagrant", group: "www-data", mount_options: ["umask=0002", "dmask=0002", "fmask=0002"]

  # Alternatively use an NFS mount, but that requires root access when machine boots
  # Also it may cause issues with npm and conflicts other NFS exports on the host 
  # config.vm.synced_folder "../", "/src", id: "smove", nfs: true, mount_options: ["nolock,vers=3,udp"]

  # Additional VM options. Crank up memory and number of cores
  config.vm.provider "virtualbox" do |vb|
    # vb.gui = true
    vb.name = "smove"
    vb.memory = 1024
    vb.cpus = 4
  end
  
  # For simplicities sake just use a shell script for provisioning
  config.vm.provision :shell,
    path: "bootstrap.sh",
    keep_color: true
end
