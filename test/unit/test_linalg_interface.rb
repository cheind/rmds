#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'
require 'mds/test/bundles/bundle_matrix_interface.rb'
require 'mds/interfaces/linalg_interface'

class TestLinalgInteface < Test::Unit::TestCase
  include MDS::Test::BundleMatrixInterface
  
  def setup
    MDS::MatrixInterface.push_interface(MDS::LinalgInterface)
  end
  
  def teardown
    MDS::MatrixInterface.pop_interface
  end
  
end
