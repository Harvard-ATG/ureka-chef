require 'spec_helper'

packages = %w(perl tcsh vim nano tar)

packages.each do |p|
  describe package(p) do
    it { should be installed }
  end
end

describe user('ureka_user') do
  it { should have_login_shell '/bin/tcsh' }
  it { should have_have_home_directory '/home/ureka_user' }
end

describe command('xpainfo') do
  its(:exit_status) { should eq 0 }
end
