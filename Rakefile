#
# mdsl - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://code.google.com/p/mdsl/
#

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

task :default => [:test_units]

desc "Run unit tests"
Rake::TestTask.new("test") { |t|
  t.pattern = FileList['test/unit/test_*.rb']
  t.verbose = true
  t.warning = false
}

desc "Run acceptance tests"
Rake::TestTask.new("acceptance") { |t|
  t.pattern = FileList['test/acceptance/acc_*.rb']
  t.verbose = false
  t.warning = false
}

desc "Run benchmarks"
Rake::TestTask.new("benchmark") { |t|
  t.pattern = FileList['test/benchmark/benchmark_*.rb']
  t.verbose = false
  t.warning = false
}

desc "Generate rdoc documentation"
Rake::RDocTask.new do |rd|
  rd.options += [ '-f', 'darkfish', '-w', '4', '-m', 'README']
  rd.rdoc_dir = "doc"
  rd.rdoc_files.include('README', 'License', 'mds/**/*.rb')
end
