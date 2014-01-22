%w{deploy}.each do |dep|
  include_recipe dep
end

node[:deploy].each do |application, deploy|
	Chef::Log.info(deploy)
	if deploy[:domains]

		
	end
end