actions :create

default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :server_names, :kind_of => String, :default => "localhost"
attribute :app_root, :kind_of => String, :required => true
attribute :enabled, :default => true
attribute :gem_home, :kind_of => String
