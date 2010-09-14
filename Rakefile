#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require 'lib/mds'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

task :default => ['test:unit:all']

namespace 'test' do

  namespace 'unit' do
  
    desc 'Run all unit tests'
    Rake::TestTask.new('all') do |t|
      t.pattern = FileList['test/unit/**/*.rb']
      t.verbose = false
      t.warning = false
    end
  
    desc 'Run unit tests for GSL interface'
    Rake::TestTask.new('gsl') do |t|
      t.pattern = FileList['test/unit/**/*gsl_*.rb']
      t.verbose = false
      t.warning = false
    end
    
    desc 'Run unit tests for Stdlib interface'
    Rake::TestTask.new('std') do |t|
      t.pattern = FileList['test/unit/**/*stdlib_*.rb']
      t.verbose = false
      t.warning = false
    end
  end
end

namespace 'docs' do
  desc "Generate rdoc documentation"
  Rake::RDocTask.new do |rd|
    rd.rdoc_dir = "doc"
    rd.rdoc_files.include('README', 'License', 'lib/**/*.rb')
  end
  
  begin
    require 'yard'
    YARD::Rake::YardocTask.new do |t|
      t.options += ['--title', "RMDS #{MDS::VERSION} Documentation"]
    end
  rescue LoadError
    warn '**YARD is missing, disabling docs:yard task'
  end
end
