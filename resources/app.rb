actions :create

default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :server_names, :kind_of => String, :default => "localhost"
attribute :server_port, :kind_of => Integer, :default => 80
attribute :app_root, :kind_of => String, :required => true
attribute :asset_location, :kind_of => String, :required => false
attribute :asset_root, :kind_of => String, :required => false
attribute :enabled, :default => true
attribute :deploy_user, :kind_of => String, :default => 'deploy'
attribute :deploy_group, :kind_of => String, :default => 'deploy'
