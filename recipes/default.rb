#
# Cookbook Name:: ureka
# Recipe:: default
#
# Copyright (c) 2016 Harvard ATG, All Rights Reserved.
#

def dl_tar(source, shortname)
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
  filepath
end

include_recipe 'build-essential::default'
include_recipe 'python::pip'

# Install Yum packages
packages = %w(perl tcsh vim nano tar libX11 libXt-devel wget bc curl tcl tk tcl-devel tk-devel gdk-pixbuf2 gtk2 libgdk-x11-2.0.so.0 libatk-1.0.so.0
              librsvg-2.so.2 librsvg-2.so.2 libuuid
 )

packages.each do|p|
  package p
end

# install xpa
xpa = dl_tar 'https://github.com/ericmandel/xpa/archive/v2.1.17.tar.gz', 'xpa'

bash 'compile_xpa_source' do
  cwd  "#{::File.dirname(xpa)}/xpa-2.1.17"
  code <<-EOH
    ./configure --with-tcl=/usr/lib64/ --with-tk=/usr/lib64/ --with-x11=/usr/lib64/ && make && make install
  EOH
  # #not_if 'xpainfo'
end

# install ds9
ds9 = dl_tar 'http://ds9.si.edu/download/linux64/ds9.linux64.7.4.tar.gz', 'ds9'
bash 'move_ds9' do
  cwd ::File.dirname(ds9)
  code 'mv ds9 /usr/bin/'
end

# Install pip libs dependent on xpa

python_pip 'git+https://github.com/ericmandel/pyds9.git' do
  action :install
end
#

ureka_filepath = "#{Chef::Config['file_cache_path'] || '/tmp'}/ureka.tar.gz"

remote_file 'http://ssb.stsci.edu/ureka/dev/Ureka_linux-rhe6_64_dev.tar.gz' do
  source 'http://ssb.stsci.edu/ureka/dev/Ureka_linux-rhe6_64_dev.tar.gz'
  path ureka_filepath
  action :create_if_missing
end

bash 'unarchive_source' do
  cwd ::File.dirname(ureka_filepath)
  code <<-EOH
   tar -zxf #{::File.basename(ureka_filepath)} -C #{::File.dirname(ureka_filepath)} &&
   mv Ureka /usr/local
 EOH
  not_if { ::File.directory?("#{Chef::Config['file_cache_path'] || '/tmp'}/ureka") || '/usr//local/Ureka' }
end

# create test user
user 'ureka_user' do
  comment 'Ureka Test User'
  home '/home/ureka_user'
  shell '/bin/tcsh'
end

# setup user
bash 'ur_normalize' do
  cwd '/usr/local/Ureka'
  code './bin/ur_normalize -s'
end

commands = ['ur_setup common primary >> .profile', 'source .profile']

commands.each do |c|
  bash 'c' do
    cwd '/home/ureka_user'
    user 'ureka_user'
    code c
  end
end
