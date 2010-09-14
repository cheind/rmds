#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'
require './test/unit/bundles/bundle_euclidean_space.rb'
require 'mds/interfaces/stdlib_interface'

class TestStdlibEuclideanSpace< Test::Unit::TestCase
  include BundleEuclideanSpace
  
  def setup
    MDS::Matrix.push_interface(MDS::StdlibInterface)
  end
  
  def teardown
    MDS::Matrix.pop_interface
  end
  
end
