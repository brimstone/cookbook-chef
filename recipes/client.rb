# Some bits stolen from https://github.com/opscode-cookbooks/chef-client
## setup
if Chef::Config[:solo]
	return if node["boxes"]["chef"].nil?
	return if node["boxes"]["chef"]["ip"].nil?
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

config = node['chef']['client']
cron "chef" do
	action :create
	minute config['minute']
	hour config['hour']
	user "root"
	command "chef-client --no-color"
end
