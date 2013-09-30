include_recipe "apache2"

install_dir = node['beanstalk_console']['directory']
conf = "#{install_dir}/config.php"

# Create directory
directory install_dir do
	owner node['apache']['user']
	group node['apache']['group']
	mode 00755
	recursive true
	action :create
end

# Download Beanstalk Console
remote_file "#{install_dir}/beanstalk_console.tar.gz" do
  owner node['apache']['user']
  group node['apache']['group']
  mode 00644
  action :create_if_missing
  source "https://github.com/ptrofimov/beanstalk_console/archive/master.tar.gz"
end

# Extract
bash 'extract-beanstalkconsole' do
	user node['apache']['user']
	group node['apache']['group']
	cwd install_dir
	code <<-EOH
		tar zxvf beanstalk_console.tar.gz
		rm -f beanstalk_console.tar.gz
		mv beanstalk_console-master/* .
		rm -rf beanstalk_console-master
	EOH
	not_if { ::File.exists?("#{install_dir}/README.md")}
end

# Set up config.php
template "#{install_dir}/config.php" do
	source 'config.php.erb'
	owner node['apache']['user']
	group node['apache']['group']
	mode 00644
end

# Enable vhost
web_app "beanstalk_console" do
  docroot node['beanstalk_console']['directory']
  log_dir node['apache']['log_dir'] 
end

# Disable default vhost
apache_site "000-default" do
  enable false
end