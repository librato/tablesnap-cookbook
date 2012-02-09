#
# Cookbook Name:: tablesnap
# Recipe:: default
#
# Copyright 2012, Librato
#
#


include_recipe "build-essential"
include_recipe "git"

version = node[:tablesnap][:version]

git "/opt/tablesnap" do
  repository node[:tablesnap][:repo]
  revision "v#{version}"
  action :sync
end

package "python-pyinotify"
package "python-pip"

# Get boto dependency from pip (apt version is too old)
bash "install_python_boto" do
  user "root"

  code <<EOH
pip install boto
EOH
  not_if "pip freeze | egrep ^boto"
end

#
# XXX: Tablesnap does not build correctly. Need to fix debian support.
#

# %w{cdbs debhelper python-support python-setuptools}.each do |p|
#   package p
# end

# execute "build tablesnap debian package" do
#   command "dpkg-buildpackage -us -uc"
#   creates "/tmp/tablesnap_#{version}_all.deb"
#   cwd "/opt/tablesnap"
# end

# dpkg_package "tablesnap" do
#   action :install
#   source "/tmp/tablesnap_#{version}_all.deb"
# end

template "/etc/init/tablesnap.conf" do
  source "upstart.conf.erb"
  variables(:logdir => node[:tablesnap][:logdir],
            :daemon => "/opt/tablesnap/tablesnap"
            )
end

service 'tablesnap' do
  provider Chef::Provider::Service::Upstart
  action [:enable]
end
