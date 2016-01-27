require 'spec_helper'

packages = %w(perl tcsh vim nano tar libX11 libXt-devel wget bc curl tcl tk tcl-devel tk-devel gdk-pixbuf2 gtk2 libgdk-x11-2.0.so.0 libatk-1.0.so.0 librsvg-2.so.2 librsvg-2.so.2 libuuid)

packages.each do |p|
  describe package(p) do
    it { should be installed }
  end
end

describe user('ureka_user') do
  it { should have_login_shell '/bin/tcsh' }
  it { should have_have_home_directory '/home/ureka_user' }
end

commands = w % (xpaget ds9 xgterm pyraf)

commands.each do|c|
  describe command(c) do
    its(:exit_status) { should eq 0 }
  end
end
#     pyraf                               ***** WORKS & fast *****
#
#     help ccdproc                  ***** WORKS & fast *****
#     python
#     >>> load pyds9               Works if I don’t run ur_setup#
