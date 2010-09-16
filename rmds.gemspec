#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require 'rubygems'
require 'rake'

$:.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'mds'

spec = Gem::Specification.new do |s|
  s.name = 'rmds'
  s.version = MDS::VERSION
  s.summary = 'Ruby Multidimensional Scaling Library'
  s.author = 'Christoph Heindl'
  s.email = 'christoph.heindl@gmail.com'
  s.homepage = 'http://github.com/cheind/rmds'
  s.description = 'Multidimensional scaling (MDS) is a set of related statistical techniques often used in information visualization for exploring similarities or dissimilarities in data.'
  s.require_path = './lib'
  s.files = FileList['LICENSE.md', 'README.md', 'Rakefile', 'lib/**/*.rb', 'test/**/*.rb', 'examples/**/*.rb'].to_a
  s.test_files = FileList['test/**/*.rb'].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.md', 'LICENSE.md']
  s.rdoc_options << '--title' << "RMDS v#{MDS::VERSION} -- Ruby Multidimensional Scaling Library"
  s.rdoc_options << '--main' << 'README.md' 
  s.rdoc_options << '-x' << 'test/*' << '-x' << 'examples/*'
                 
                 
end


