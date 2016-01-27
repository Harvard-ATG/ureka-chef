#
# Cookbook Name:: ureka
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

packages = %w(perl tcsh vim nano tar libx11-6 libXft2 lib32z1 wget bc curl)

packages.each do|p|
  package p
end

user 'ureka_user' do
  comment 'Ureka Test User'
  home '/home/ureka_user'
  shell '/bin/tcsh'
end

src_filepath  = "#{Chef::Config['file_cache_path'] || '/tmp'}/ureka.tar.gz"

remote_file 'http://ssb.stsci.edu/ureka/dev/Ureka_linux-rhe6_64_dev.tar.gz' do
 source 'http://ssb.stsci.edu/ureka/dev/Ureka_linux-rhe6_64_dev.tar.gz'
 path src_filepath
end

bash 'unarchive_source' do
 cwd  ::File.dirname(src_filepath)
 code <<-EOH
   tar -zxf #{::File.basename(src_filepath)} -C #{::File.dirname(src_filepath)}
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
