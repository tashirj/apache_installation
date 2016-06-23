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
    mv #{apache_install_dir}/ngx_openresty-* #{apache_install_dir}/ngx_openresty
    cd #{apache_install_dir}/ngx_openresty
    ./configure --prefix=/opt/openresty --with-pcre-jit --with-pcre --with-http_ssl_module --with-luajit
    make
    make install
    PATH=/opt/openresty/nginx/sbin:$PATH
    export PATH
    nginx -p `pwd`/ -c conf/nginx.conf
    ln -s /usr/local/openresty/nginx/conf /etc/nginx
    nginx -p `pwd`/ -c conf/nginx.conf
    EOH
  only_if { ::File.exists?(apache_install_dir) }
end
