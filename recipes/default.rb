#
# Cookbook Name:: http_installation
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
apache_install_dir=node[:http_installation][:install_dir]

execute 'openresty_package_download' do
  command 'wget http://openresty.org/download/ngx_openresty-1.5.8.1.tar.gz'
  cwd '/opt/'
  not_if { File.exists?("/opt/ngx_openresty*") }
end

bash 'extract_openresty' do
  cwd ::File.dirname(src_filepath)
  code <<-EOH 
    tar -xzf #{src_filename} -C #{apache_install_dir}
    mv #{apache_install_dir}/httpd* #{apache_install_dir}/httpd
    EOH
  not_if { ::File.exists?(apache_install_dir) }
end
