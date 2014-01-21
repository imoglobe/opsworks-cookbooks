def opsworks_cookbook(name, version = '>= 0.0.0', options = {})
  cookbook name, version, { path: "/vendor/cookbooks/#{name}" }.merge(options)
end

site :opscode

opsworks_cookbook 'apt'
opsworks_cookbook 'git'
opsworks_cookbook 'build-essential'
opsworks_cookbook 'nginx', '>= 1.6'
opsworks_cookbook 'docker', '>= 0.9.0'
opsworks_cookbook 'user'
opsworks_cookbook 'sudo'