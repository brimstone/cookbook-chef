# During container build
## solo.rb
Stored in /tmp/chef
Configuration file chef-solo uses to setup chef-server

# During container lifespan
## backup
Stored in /etc/cron.d
Cron job that runs and backs up chef settings to /var/backups
Cron job that runs chef-client against itself periodically

## chef_server_backup.rb
Stored in /root
Knife script to backup chef-server

## knife.rb
Stored in /root/.chef
Knife config to be used locally.
Initially configured to use 'admin' but onboot.conf should change it to use 'chef-server' instead, after chef-client has registered itself

## onboot.conf
Stored in /etc/init
Upstart script that:
* Register server using validator.pem
* Use admin.pem to upgrade chef-server client to admin
* Checks for backups in /var/backups and injects them into the chef-server as it starts blank

