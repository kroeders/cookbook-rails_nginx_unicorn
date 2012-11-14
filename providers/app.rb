action :create do
  common = {
    :name => new_resource.name,
    :server_names => new_resource.server_names,
    :server_port => new_resource.server_port,
    :app_root => new_resource.app_root,
    :asset_location => new_resource.asset_location,
    :asset_root => new_resource.asset_root,
    :enabled => new_resource.enabled,
    :user => new_resource.deploy_user,
    :group => new_resource.deploy_group,
  }

  directory common[:app_root] do
    owner common[:user]
    group common[:group]
    recursive true
  end

  directory "#{common[:app_root]}/shared" do
    owner common[:user]
    group common[:group]
    recursive true
  end

  %w{log pids}.each do |dir|
    directory "#{common[:app_root]}/shared/#{dir}" do
      owner common[:user]
      group common[:group]
      recursive true
    end
  end

  template "#{node['nginx']['dir']}/sites-available/#{common[:name]}.conf" do
    mode 0644
    source "nginx.conf.erb"
    cookbook "rails_nginx_unicorn"
    variables common
    notifies :reload, "service[nginx]"
  end

  nginx_site "#{common[:name]}.conf" do
    enable common[:enabled]
  end

  new_resource.updated_by_last_action(true)
end

def load_current_resource
  @app = Chef::Resource::RailsNginxUnicornApp.new(new_resource.name)
end
