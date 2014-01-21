%w{deploy}.each do |dep|
  include_recipe dep
end
Chef::Log.info(node[:deploy])
node[:deploy].each do |application, deploy|
	Chef::Log.info(application)
	Chef::Log.info(deploy)

	opsworks_deploy_dir do
		user deploy[:user]
		group deploy[:group]
		path deploy[:deploy_to]
	end

	opsworks_deploy do
		deploy_data deploy
		app application
	end

	template "#{node[:dokku][:root]}/#{application}/ssl/server.crt" do
		mode '0600'
		owner 'dokku'
		source "ssl.key.erb"
		variables :key => deploy[:ssl_certificate]
		only_if do
			deploy[:ssl_support]
		end
		action :create_if_missing
	end

	template "#{node[:dokku][:root]}/#{application}/ssl/server.key" do
		mode '0600'
		owner 'dokku'
		source "ssl.key.erb"
		variables :key => deploy[:ssl_certificate_key]
		only_if do
			deploy[:ssl_support]
		end
		action :create_if_missing
	end

	template "#{node[:dokku][:root]}/#{application}/ssl/server.ca" do
		mode '0600'
		owner 'dokku'
		source "ssl.key.erb"
		variables :key => deploy[:ssl_certificate_ca]
		only_if do
			deploy[:ssl_support] && deploy[:ssl_certificate_ca]
		end
		action :create_if_missing
	end

	execute "git push" do
		command "git push ubuntu@localhost:#{application} #{deploy[:scm][:revision]}"
		cwd "#{deploy[:deploy_to]}/current"
	end
end