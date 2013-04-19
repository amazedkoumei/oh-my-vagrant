#
# Cookbook Name:: libs
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum::epel"

# for nokogiri
# http://nokogiri.org/tutorials/installing_nokogiri.html
%w{libxml2 libxml2-devel libxslt libxslt-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

# for pg
# https://bitbucket.org/ged/ruby-pg/wiki/Home
# http://serverfault.com/questions/316703/how-to-install-libpq-dev-on-centos-5-5
=begin
%w{postgresql-devel}.each do |pkg|
  package pkg do
    action :install
  end
end
=end