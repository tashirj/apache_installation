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
  interpreter "bash"
  code <<-EOH
    tar -xzf /opt/ngx_openresty-1.5.8.1.tar.gz -C #{apache_install_dir}
    rm -rf /opt/ngx_openresty-1.5.8.1.tar.gz
    mv #{apache_install_dir}/ngx_openresty* #{apache_install_dir}/ngx_openresty
    cd #{apache_install_dir}/ngx_openresty
    ./configure --prefix=/opt/openresty --with-pcre-jit --with-pcre --with-http_ssl_module --with-luajit
    make
    make install
    cd /opt/openresty/nginx/sbin/
    ./nginx -c ../conf/nginx.conf
    ln -s /opt/openresty/nginx/conf /etc/nginx
    ./nginx -c conf/nginx.conf
    EOH
  only_if { ::File.exists?(apache_install_dir) }
end
execute 'set-env' do
	command 'export PATH=$PATH:/opt/openresty/nginx/sbin'
end

