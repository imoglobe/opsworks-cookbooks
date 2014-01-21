file "#{node['dokku']['root']}/.ssh/authorized_keys" do
  	action :delete

  	only_if do
      	::File.exists?("#{node['dokku']['root']}/.ssh/authorized_keys")
    end
end

node['dokku']['ssh_keys'].each do |user, key|
  	# TODO make this into an LWRP
	execute "sshcommand_acl-add_key" do
		command "echo '#{key}' | sudo sshcommand acl-add dokku #{user}"
		cwd node['dokku']['root']
	end
end
