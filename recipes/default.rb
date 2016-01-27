#
# Cookbook Name:: ureka
# Recipe:: default
#
# Copyright (c) 2016 Harvard ATG, All Rights Reserved.
#

def dl_tar (source, shortname)
  filepath = "#{Chef::Config['file_cache_path'] || '/tmp'}/#{shortname}.tar.gz"

  remote_file source do
    source source
    path filepath
    action :create_if_missing
  end

  bash "unarchive_#{shortname}_source" do
    cwd ::File.dirname(filepath)
    code <<-EOH
     tar -zxf #{::File.basename(filepath)} -C #{::File.dirname(filepath)}
   EOH
    not_if { ::File.directory?("#{Chef::Config['file_cache_path'] || '/tmp'}/#{shortname}") }
  end
  return filepath
end

include_recipe 'build-essential::default'
include_recipe 'python::pip'

# Install Yum packages
packages = %w(perl tcsh vim nano tar libX11 wget bc curl tcl tk tcl-devel tk-devel)

packages.each do|p|
  package p
end

# Install pip libs

python_pip "git+https://github.com/ericmandel/pyds9.git"

# install xpa
xpa = dl_tar "https://github.com/ericmandel/xpa/archive/v2.1.17.tar.gz", "xpa"

bash 'compile_nginx_source' do
  cwd  ::File.dirname(xpa)
  code <<-EOH
    ./configure --with-tcl=/usr/lib64/ --with-tk=/usr/lib64/ --with-x11=/usr/lib64/ && make && make install
  EOH
  not_if 'xpainfo'
end


# create test user
user 'ureka_user' do
  comment 'Ureka Test User'
  home '/home/ureka_user'
  shell '/bin/tcsh'
end

ureka_filepath = "#{Chef::Config['file_cache_path'] || '/tmp'}/ureka.tar.gz"

remote_file 'http://ssb.stsci.edu/ureka/dev/Ureka_linux-rhe6_64_dev.tar.gz' do
  source 'http://ssb.stsci.edu/ureka/dev/Ureka_linux-rhe6_64_dev.tar.gz'
  path ureka_filepath
  action :create_if_missing
end

bash 'unarchive_source' do
  cwd ::File.dirname(ureka_filepath)
  code <<-EOH
   tar -zxf #{::File.basename(ureka_filepath)} -C #{::File.dirname(ureka_filepath)}
   Ureka/bin/ur_normalize -s
 EOH
  not_if { ::File.directory?("#{Chef::Config['file_cache_path'] || '/tmp'}/ureka") }
end

bash 'run_ureka_setup' do
  cwd '/root'
  code <<-EOH
    ["/bin/bash", "-c", "echo \"ur_setup common primary\" >> .profile"]
    ["/bin/bash", "-c", "source .profile"]
  EOH
end
