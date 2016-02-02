require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

task default: :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = ActivemerchantPayboxDirectPlus::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ActiveMerchant PayboxDirectPlusGateway #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
