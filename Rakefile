require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "asf-soap-adapter"
    gem.summary = %Q{ASF-Soap-Adapter is an improved version of the ActiveSalesforce (ASF) Adapter with support Chatter and general wrapper object.}
    gem.description = %Q{ASF-Soap-Adapter is an improved version of ActiveSalesforce (ASF) is a Rails connection adapter that provides direct access to Salesforce.com hosted data and metadata via the ActiveRecord model layer. Objects, fields, and relationships are all auto surfaced as active record attributes and rels. It has been patched to V20 of the Web Services API and has support Chatter model.}
    gem.email = "raygao2000@yahoo.com"
    gem.homepage = "http://github.com/raygao/asf-soap-adapter"
    gem.authors = ["Doug Chasman","Luigi Montanez","Senthil Nayagam","Justin Ball","Jesse Hallett", "Andrew Freeberg", "Blaine Schanfeldt", "Matte Edens", "Raymond Gao"]

    # Requiring RForce as an add-on gem, rather than hard-code the 0.4.0
    gem.add_dependency('rforce', '>=0.4.1')
    gem.add_dependency('builder', '>= 1.2.4')
    gem.add_dependency('hpricot', '>=0.8.2')

    #gem.add_dependency('rails', '>= 2.3.3')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "asf-soap-adapter #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
