require 'serverspec'

set :os, family: 'redhat', release: '7', arch: 'x86_64'
set :backend, :exec
