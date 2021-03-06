#
# RMDS - Ruby Multidimensional Scaling Library
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
      t.pattern = FileList['test/unit/**/test_*.rb']
      t.verbose = false
      t.warning = false
    end
  
    desc 'Run unit tests for GSL interface'
    Rake::TestTask.new('gsl') do |t|
      t.pattern = FileList['test/unit/**/test_*gsl_*.rb']
      t.verbose = false
      t.warning = false
    end
    
    desc 'Run unit tests for Stdlib interface'
    Rake::TestTask.new('std') do |t|
      t.pattern = FileList['test/unit/**/test_*stdlib_*.rb']
      t.verbose = false
      t.warning = false
    end
    
    desc 'Run unit tests for Linalg interface'
    Rake::TestTask.new('linalg') do |t|
      t.pattern = FileList['test/unit/**/test_*linalg_*.rb']
      t.verbose = false
      t.warning = false
    end
  end
  
  namespace 'bench' do
  
    desc 'Run all benchmarks'
    task('all') do |t|
      require 'test/benchmark/benchmark_metric'
    end
    
  end
  
end

namespace 'docs' do

  desc "Generate rdoc documentation"
  Rake::RDocTask.new do |rd|
    rd.rdoc_dir = "doc"
    rd.main = 'README.md'
    rd.options << '--title' << "RMDS #{MDS::VERSION} Documentation"
    rd.rdoc_files.include('README.md', 'LICENSE.md', 'lib/**/*.rb', 'examples/**/*.rb')
  end
  
  begin
    require 'yard'
    YARD::Rake::YardocTask.new do |t|
      t.files   = ['lib/**/*.rb', 'examples/**/*.rb', '-', 'LICENSE.md'] 
      t.options = ['--no-cache', '--title', "RMDS #{MDS::VERSION} Documentation"]
    end
  rescue LoadError
    warn '**YARD is missing, disabling docs:yard task'
  end
end
