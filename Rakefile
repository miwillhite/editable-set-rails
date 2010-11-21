require 'rake'
require 'rake/rdoctask'
require 'rspec/core/rake_task'

desc 'Test the editable_set plugin.'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w('--color')
  t.pattern = FileList['spec/**/*_spec.rb']
end

desc 'Generate documentation for the editable_set plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'EditableSet'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end