#
# Cookbook Name:: eurka
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

packages = ['perl', 'tcsh', 'vim', 'nano']

packages.each {|p|
  # Package resource
  package p do # Name of the package to install
    action :install # Install a package - if version is provided, install that specific version (Default)
  end
}
  
