action :create do
  common = {
    :name => new_resource.name,
    :server_names => new_resource.server_names,
    :app_root => new_resource.app_root,
    :enabled => new_resource.enabled,
    :gem_home => new_resource.gem_home
  }

  directory common[:app_root] do
    owner node[:rails_nginx_unicorn][:deploy_user]
    recursive true
  end

  %w{log pids}.each do |dir|
    directory "#{common[:app_root]}/shared/#{dir}" do
      owner node[:rails_nginx_unicorn][:deploy_user]
      recursive true
    end
  end

  template "#{node[:nginx][:dir]}/sites-available/#{common[:name]}.conf" do
    mode 0644
    source "nginx.conf.erb"
    cookbook "rails_nginx_unicorn"
    variables common
    notifies :reload, "service[nginx]"
  end

  template "#{node[:unicorn][:config_path]}/#{common[:name]}.conf.rb" do
    mode 0644
    source "unicorn.conf.erb"
    cookbook "rails_nginx_unicorn"
    variables common
  end

  nginx_site "#{common[:name]}.conf" do
    enable common[:enabled]
  end
end

def load_current_resource
  @app = Chef::Resource::RailsNginxUnicornApp.new(new_resource.name)
end
