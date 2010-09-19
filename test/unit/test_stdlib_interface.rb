#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'
require 'mds/test/bundles/bundle_matrix_interface.rb'
require 'mds/interfaces/stdlib_interface'

class TestStdlibInterface < Test::Unit::TestCase
  include MDS::Test::BundleMatrixInterface
  
  def setup
    MDS::Matrix.push_interface(MDS::StdlibInterface)
  end
  
  def teardown
    MDS::Matrix.pop_interface
  end
  
end
