require 'foodcritic'
task :default => [:foodcritic]
FoodCritic::Rake::LintTask.new do |t|
  t.options = { :include_rules => ['foodcritic/customink.rb', 'foodcritic/etsy.rb'] }
end
