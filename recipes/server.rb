remote_file "/tmp/chef-server.deb" do
	source "https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.11-1.ubuntu.12.04_amd64.deb"
	checksum "864e447580552a91b3de8be6c24efde2c5a6328a2b4dca8d5afa4347cb4b4868"
	action :create_if_missing
end

dpkg_package "chef-server" do
	source "/tmp/chef-server.deb"
	action :install
end

execute "/usr/bin/chef-server-ctl reconfigure"

execute "cp /etc/chef-server/chef-validator.pem /vagrant/chef-validator.pem" do
	only_if { ::File.directory?("/vagrant") }
end

execute "cp /etc/chef-server/admin.pem /etc/chef/client.pem"

directory "/root/.chef" do
end

template "/root/.chef/knife.rb" do
	source "knife.rb.erb"
end

execute "sleep 5"

execute "knife cookbook -c /root/.chef/knife.rb upload -a -o /vagrant/cookbooks/" do
	only_if { ::File.directory?("/vagrant") }
end

execute "knife role -c /root/.chef/knife.rb from file /vagrant/roles/*.json" do
	only_if { ::File.directory?("/vagrant") }
end
