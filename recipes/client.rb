# Some bits stolen from https://github.com/opscode-cookbooks/chef-client
## setup
if Chef::Config[:solo]
	server = "https://" + node["boxes"]["chef"]["ip"]
else
	server = Chef::Config[:chef_server_url]
	#server = { 'ip' => search(:node, "name:chef.*").first["ipaddress"] }
end

## directives

directory "/etc/chef"

if Chef::Config[:solo]
	execute "cp /vagrant/chef-validator.pem /etc/chef/" do
		not_if { ::File.exists?("/etc/chef/chef-validator.pem") }
	end
else
	file Chef::Config[:validation_key] do
		action :delete
		backup false
		only_if { ::File.exists?(Chef::Config[:client_key]) }
	end
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
