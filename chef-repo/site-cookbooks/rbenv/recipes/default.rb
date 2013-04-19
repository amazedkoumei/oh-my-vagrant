#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w{git gcc make readline-devel openssl-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

user = "vagrant"
group = "vagrant"
home = "/home/#{user}"
version = "1.9.3-p362"

git "#{home}/.rbenv" do
  user user
  group group
  repository "git://github.com/sstephenson/rbenv.git"
  reference "master"
  # action :sync
  action :checkout
end

bash "rbenv" do
  user user
  group group
  cwd home
  environment "HOME" => home

  code <<-EOC
    echo 'export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"' >> #{home}/.bashrc
    echo 'eval "$(rbenv init -)"' >> #{home}/.bashrc
    source ~/.bashrc
    rbenv install #{version}
    rbenv global #{version}
    rbenv versions
    rbenv rehash
  EOC

  not_if { File.exists?("#{home}/.rbenv/shims/ruby") }
end