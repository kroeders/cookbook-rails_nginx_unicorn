if node['nginx']['source']
  include_recipe 'nginx::source'
else
  include_recipe 'nginx'
end
