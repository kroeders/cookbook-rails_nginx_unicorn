actions :create, :enable, :disable, :delete

default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :server_names, :kind_of => String, :default => "localhost"
attribute :app_root, :kind_of => String, :required => true
