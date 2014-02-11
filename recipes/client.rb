## setup
if Chef::Config[:solo]
	server = node["boxes"]["chef"]
else
	server = { 'ip' => search(:node, "name:chef.*").first["ipaddress"] }
end

## directives

directory "/etc/chef"

execute "cp /vagrant/chef-validator.pem /etc/chef/" do
	not_if { ::File.exists?("/etc/chef/chef-validator.pem") }
end

template "/etc/chef/client.rb" do
	source "client.rb.erb"
	variables({ :server => server})
end

template "/etc/chef/first-boot.json" do
	source "first-boot.json.erb"
end

template "/etc/cron.d/chef" do
	source "cron.chef.erb"
end
