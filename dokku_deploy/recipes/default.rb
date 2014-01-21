%w{deploy}.each do |dep|
  include_recipe dep
end

node[:deploy].each do |application, deploy|
	Chef::Log.debug(application)
	Chef::Log.debug(deploy)
	
	opsworks_deploy_dir do
		user deploy[:user]
		group deploy[:group]
		path deploy[:deploy_to]
	end

	opsworks_deploy do
		deploy_data deploy
		app application
	end

	template "#{node[:dokku][:root]}/#{application[:domains]}/ssl/server.crt" do
		mode '0600'
		owner 'dokku'
		source "ssl.key.erb"
		variables :key => application[:ssl_certificate]
		only_if do
			application[:ssl_support]
		end
		action :create_if_missing
	end

	template "#{node[:dokku][:root]}/#{application[:domains]}/ssl/server.key" do
		mode '0600'
		owner 'dokku'
		source "ssl.key.erb"
		variables :key => application[:ssl_certificate_key]
		only_if do
			application[:ssl_support]
		end
		action :create_if_missing
	end

	template "#{node[:dokku][:root]}/#{application[:domains]}/ssl/server.ca" do
		mode '0600'
		owner 'dokku'
		source "ssl.key.erb"
		variables :key => application[:ssl_certificate_ca]
		only_if do
			application[:ssl_support] && application[:ssl_certificate_ca]
		end
		action :create_if_missing
	end

	execute "git push" do
		command "git push ubuntu@localhost:#{application[:domains]} master"
		cwd deploy[:deploy_to]
	end
end