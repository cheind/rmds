#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'
require './test/unit/bundles/bundle_matrix_interface.rb'
require 'mds/interfaces/linalg_interface'

class TestLinalgInteface < Test::Unit::TestCase
  include BundleMatrixInterface
  
  def setup
    MDS::Matrix.push_interface(MDS::LinalgInterface)
  end
  
  def teardown
    MDS::Matrix.pop_interface
  end
  
end
