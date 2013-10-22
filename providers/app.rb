action :create do
  common = {
    :name => new_resource.name,
    :server_names => new_resource.server_names,
    :http_port => new_resource.http_port,
    :https_port => new_resource.https_port,
    :app_root => new_resource.app_root,
    :asset_location => new_resource.asset_location,
    :asset_root => new_resource.asset_root,
    :enabled => new_resource.enabled,
    :user => new_resource.deploy_user,
    :group => new_resource.deploy_group,
    :rvm_ruby_string => new_resource.rvm_ruby_string,
    :rails_env => new_resource.rails_env,
    :force_ssl => new_resource.force_ssl,
    :ssl => new_resource.ssl,
    :ssl_certificate_path => new_resource.ssl_certificate_path,
    :ssl_certificate_key_path => new_resource.ssl_certificate_key_path,
    :include_forwarding_headers => new_resource.include_forwarding_headers,
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

  %w{log pids config}.each do |dir|
    directory "#{common[:app_root]}/shared/#{dir}" do
      owner common[:user]
      group common[:group]
      recursive true
    end
  end

  template "#{common[:app_root]}/shared/config/unicorn.rb" do
    mode 0644
    source "unicorn-conf.rb.erb"
    cookbook "rails_nginx_unicorn"
    variables common
  end

 template "/etc/init.d/#{common[:name]}" do
    mode 0744
    source "unicorn-init.erb"
    cookbook "rails_nginx_unicorn"
    variables common
  end

  service common[:name] do
    supports :start => true, :stop => true, :restart => true
    action :enable
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
