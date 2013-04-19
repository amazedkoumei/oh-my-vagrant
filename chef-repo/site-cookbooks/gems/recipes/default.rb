#
# Cookbook Name:: gems
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
[
  ["bundler", "1.3.5"]
].each do |pkg, version|
  gem_package pkg do
    gem_binary "/home/vagrant/.rbenv/shims/gem"
    version version
    action :install
  end
end