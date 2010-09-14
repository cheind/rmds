#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

task :default => [:test_units]


namespace 'test' do

  desc "Run unit tests"
  Rake::TestTask.new("unit") do |t|
    t.pattern = FileList['test/unit/**/*.rb']
    t.verbose = false
    t.warning = false
  end
  
end

desc "Generate rdoc documentation"
Rake::RDocTask.new do |rd|
  rd.options += [ '-f', 'darkfish', '-w', '4', '-m', 'README']
  rd.rdoc_dir = "doc"
  rd.rdoc_files.include('README', 'License', 'lib/**/*.rb')
end
