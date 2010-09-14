#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require 'rubygems'
require 'rake'

spec = Gem::Specification.new do |s|
  s.name = 'mdsl'
  s.version = '0.8'
  s.summary = 'Ruby Multidimensional Scaling Library'
  s.author = 'Christoph Heindl'
  s.email = 'christoph.heindl@gmail.com'
  s.homepage = 'http://code.google.com/p/mdsl/'
  s.description = 'Multidimensional scaling (MDS) is a set of related statistical techniques often used in information visualization for exploring similarities or dissimilarities in data.'
  s.require_path = '.'
  s.files = FileList['mds.rb', 'License', 'README', 'Rakefile', 'mds/**/*.rb', 'test/**/*', 'example/**/*'].to_a
  s.test_files = FileList['test/unit/*'].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'License']
  s.rdoc_options << '--title' << 'mdsl -- Ruby Multidimensional Scaling Library' << 
                           '--main' << 'README' <<
                           '-x' << 'test/*' << '-x' << 'example/*'
end


