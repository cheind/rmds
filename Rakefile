#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require 'lib/mds'
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

namespace 'docs' do
  desc "Generate rdoc documentation"
  Rake::RDocTask.new do |rd|
    rd.rdoc_dir = "doc"
    rd.rdoc_files.include('README', 'License', 'lib/**/*.rb')
  end
  
  begin
    require 'yard'
    YARD::Rake::YardocTask.new do |t|
      t.options += ['--title', "rmds #{MDS::VERSION} Documentation"]
    end
  rescue LoadError
  end
  
  
end
