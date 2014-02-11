dpkg_package "chef-server" do
	source "/vagrant/packages/chef-server.deb"
	action :install
end

execute "chef-server-ctl reconfigure"

execute "cp /etc/chef-server/chef-validator.pem /vagrant/chef-validator.pem"

execute "cp /etc/chef-server/admin.pem /etc/chef/client.pem"

directory "/root/.chef" do
end

template "/root/.chef/knife.rb" do
	source "knife.rb.erb"
end

execute "sleep 5"

execute "knife cookbook -c /root/.chef/knife.rb upload -a -o /vagrant/cookbooks/"

execute "knife role -c /root/.chef/knife.rb from file /vagrant/roles/*.json"
