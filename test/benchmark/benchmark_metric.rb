#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require 'benchmark'

$:.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
require 'mds'
require 'mds/interfaces/gsl_interface'
require 'mds/interfaces/stdlib_interface'
require 'mds/interfaces/linalg_interface'

def run_benchmark(b, obs, dims)
  x = nil; d = nil; proj = nil
  puts
  b.report("  create") {x = MDS::Matrix.create_random(obs, dims)}
  b.report("  sq-dist") {d = MDS::Metric.squared_distances(x)}
  b.report("  mds") {proj = MDS::Metric.projectd(d, dims)}
  printf " >total   "
end


n = 10
d = 2
puts "-----------------"
puts "Benchmarking RMDS for #{n} observations in #{d}-dimensional space"
Benchmark.bm(10) do |x|
  x.report("stdlib:") {MDS::Matrix.interface = MDS::StdlibInterface; run_benchmark(x,n,d)}
  x.report("gsl:")    {MDS::Matrix.interface = MDS::GSLInterface; run_benchmark(x,n,d)}
  x.report("linalg:") {MDS::Matrix.interface = MDS::LinalgInterface; run_benchmark(x,n,d)}
end

n = 100
d = 5
puts "-----------------"
puts "Benchmarking RMDS for #{n} observations in #{d}-dimensional space"
Benchmark.bm(10) do |x|
  #x.report("stdlib:") {MDS::Matrix.interface = MDS::StdlibInterface; run_benchmark(x,n,d)}
  x.report("gsl:")    {MDS::Matrix.interface = MDS::GSLInterface; run_benchmark(x,n,d)}
  x.report("linalg:") {MDS::Matrix.interface = MDS::LinalgInterface; run_benchmark(x,n,d)}
end

n = 1000
d = 10
puts "-----------------"
puts "Benchmarking RMDS for #{n} observations in #{d}-dimensional space"
Benchmark.bm(10) do |x|
  #x.report("stdlib:") {MDS::Matrix.interface = MDS::StdlibInterface; run_benchmark(x,n,d)}
  x.report("gsl:")    {MDS::Matrix.interface = MDS::GSLInterface; run_benchmark(x,n,d)}
  x.report("linalg:") {MDS::Matrix.interface = MDS::LinalgInterface; run_benchmark(x,n,d)}
end
