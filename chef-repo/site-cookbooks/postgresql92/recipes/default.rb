#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
gem_package "libshadow" do
  gem_binary "/home/vagrant/.rbenv/shims/gem"
  version "1.0.0"
  action :install
end

user = "postgres"
group = "postgres"
home = "/var/lib/pgsql"

group group do
  gid 26
end

user user do
  shell "/bin/bash"
  comment "PostgreSQL Server"
  home home
  password ""
  gid user
  system true
  uid 26
  supports :manage_home => false
end

# TODO: make ln to /usr/pgsql-9.2/bin
=begin
bash "source #{home}/.bashrc" do
  user user
  group group
  cwd home
  environment "HOME" => home

  code <<-EOC
    echo 'export PATH="/usr/pgsql-9.2/bin:$PATH"' >> #{home}/.bashrc
    source #{home}/.bashrc
  EOC

  not_if { File.exists?("#{home}/.bashrc") }
end
=end

rpm_file_path = "/tmp"
rpm_file_name = "pgdg-centos92-9.2-6.noarch.rpm"
remote_uri = "http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/#{rpm_file_name}"
checksum = `echo -n #{rpm_file_name} | sha256sum`

remote_file "#{rpm_file_path}/#{rpm_file_name}" do
  source remote_uri
  checksum checksum
end

%w{postgresql postgresql-server postgresql-devel}.each do |pkg|
  package pkg do
    action :remove
  end  
end

%w{postgresql92 postgresql92-server postgresql92-devel postgresql92-libs postgresql92-contrib}.each do |pkg|
  package pkg do
    #source "#{rpm_file_path}/#{rpm_file_name}"
    #provider Chef::Provider::Package::Yum
    action :install
  end  
end

# for /etc/init.d/postgresql-9.2 l63
# this script run runuser instead of su when user is authorized x for /sbin/runuser 
file "/sbin/runuser" do
  mode 0744
end

pgdata_path = "/var/lib/pgsql/9.2/data"
execute "/sbin/service postgresql-9.2 initdb" do
  not_if { File.exists?("#{pgdata_path}/PG_VERSION") }
end

hba_file = "pg_hba.conf"
template_file = "#{pgdata_path}/#{hba_file}"

template template_file do
  source "#{hba_file}.erb"
  owner "postgres"
  group "postgres"
  mode 0600
end

service "postgresql-9.2" do
  service_name "postgresql-9.2"
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
  subscribes :restart, resources(:template => template_file)
end