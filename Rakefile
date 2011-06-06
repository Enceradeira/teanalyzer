require 'rake'
require 'rspec/core/rake_task'
require 'echoe'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec


Echoe.new('teanalyzer', '0.9.0') do |p|
  p.description = "An analyzer for keyboard typing efforts"
  p.url = "https://github.com/Enceradeira/teanalyzer"
  p.author = "Jorg Jenni"
  p.email = "jorg.jenni@jennius.co.uk"
  p.development_dependencies = []

end
