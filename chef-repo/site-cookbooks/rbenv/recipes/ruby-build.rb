#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "rbenv"

download_dir = "/tmp/ruby-build"

git download_dir do
  repository "git://github.com/sstephenson/ruby-build.git"
  reference "master"
  # action :sync
  action :checkout
end

bash "install-rubybuild" do
  not_if 'which ruby-build'
  code <<-EOC
    cd #{download_dir}
    ./install.sh
  EOC
end

