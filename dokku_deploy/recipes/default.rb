include_recipe 'deploy'

node[:deploy].each do |application, deploy|

	opsworks_deploy_dir do
		user deploy[:user]
		group deploy[:group]
		path deploy[:deploy_to]
	end

	opsworks_deploy do
		deploy_data deploy
	end

  	git deploy[:deploy_to] do
		repository node['dokku']['git_repository']
		reference node['dokku']['git_revision']
		action :push
	end
end