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
remote_file "#{install_dir}/beanstalk_console.zip" do
  owner node['apache']['user']
  group node['apache']['group']
  mode 00644
  action :create_if_missing
  source "https://github.com/ptrofimov/beanstalk_console/archive/master.zip"
end

# Extract
bash 'extract-beanstalkconsole' do
	user node['apache']['user']
	group node['apache']['group']
	cwd install_dir
	code <<-EOH
		rm -rf *
		unzip master.zip
		rm -rf master.zip
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