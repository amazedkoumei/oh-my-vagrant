# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "centos"

  config.vm.network :hostonly, "192.168.33.11"
  #config.vm.host_name = "helios"

  config.vm.share_folder "helios", "/home/vagrant/helios", "~/src/helios"

end
