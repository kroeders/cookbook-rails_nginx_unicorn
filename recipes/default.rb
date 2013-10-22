recipe = node['nginx']['install_recipe'] || 'nginx'
include_recipe recipe
