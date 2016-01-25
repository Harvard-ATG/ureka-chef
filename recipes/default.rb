#
# Cookbook Name:: eurka
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

packages = %w(perl tcsh vim nano tar)

packages.each do|p|
  package p
end

user 'ureka_user' do
  comment 'Ureka Test User'
  home '/home/ureka_user'
  shell '/bin/tcsh'
end

# src_filepath  = "#{Chef::Config['file_cache_path'] || '/tmp'}/ureka.tar.gz"
# remote_file 'http://ssb.stsci.edu/ureka/1.5.1/Ureka_linux-rhe6_64_1.5.1.tar.gz' do
#  source 'http://ssb.stsci.edu/ureka/1.5.1/Ureka_linux-rhe6_64_1.5.1.tar.gz'
#  path src_filepath
# end
#
# bash 'unarchive_source' do
#  cwd  ::File.dirname(src_filepath)
#  code <<-EOH
#    tar zxf #{::File.basename(src_filepath)} -C #{::File.dirname(src_filepath)}
#  EOH
#  not_if { ::File.directory?("#{Chef::Config['file_cache_path'] || '/tmp'}/ureka") }
# end
#
bash 'install ureka' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
    curl http://ssb.stsci.edu/ureka/1.5.1/install_ureka_1.5.1 |sh
  EOH
end

