#
# Cookbook Name:: http_installation
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
tarball = "httpd-#{node[:http_installation][:version]}.tar.gz"
download_file = "#{node[:http_installation][:download_url]}/#{tarball}"

remote_file "#{Chef::config[:file_cache_path]}/#{tarball}" do
  source download_file
  action :create_if_missing
  mode 00644
end

apache_install_dir=node[:http_installation][:install_dir]

execute "tar" do
  user "root"
  group "root"
  cwd apache_install_dir
  action :run
  command "tar xvzf #{Chef::config[:file_Cache_path]}/#{tarball}"
  not_if{ ::File.directory?("#{apache_install_dir}/httpd-#{version}")
end
execute "move" do
  user "root"
  group "root"
  cwd apache_install_dir
  action :run
  command "mv httpd* httpd"
  not_if{ ::File.directory?("#{apache_install_dir}/httpd")
end