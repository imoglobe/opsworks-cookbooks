%w{deploy git}.each do |dep|
  include_recipe dep
end

node[:deploy].each do |application, deploy|
	deploy[:application_type] = 'other'

	opsworks_deploy_dir do
		user deploy[:user]
		group deploy[:group]
		path deploy[:deploy_to]
	end

	opsworks_deploy do
		deploy_data deploy
		app application
	end

end