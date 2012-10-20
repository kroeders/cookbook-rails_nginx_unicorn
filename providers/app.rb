action :create do
  common = {
    :name => new_resource.name,
    :server_names => new_resource.server_names,
    :app_root => new_resource.app_root,
    :enabled => new_resource.enabled
  }

  directory new_resource.app_root do
    owner node[:rails_nginx_unicorn][:deploy_user]
    recursive true
  end

  directory "#{new_resource.app_root}/shared/log" do
    owner node[:rails_nginx_unicorn][:deploy_user]
    recursive true
  end

  template "#{node[:nginx][:dir]}/sites-available/#{new_resource.name}.conf" do
    mode 0644
    source "nginx.conf.erb"
    cookbook "rails_nginx_unicorn"
    variables common
    notifies :reload, "service[nginx]"
  end

  nginx_site "#{new_resource.name}.conf" do
    enable common[:enabled]
  end
end

def load_current_resource
  @app = Chef::Resource::RailsNginxUnicornApp.new(new_resource.name)
end
