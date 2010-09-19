#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'
require 'mds/interfaces/gsl_interface'
require 'mds/test/bundles/bundle_matrix_interface.rb'

class TestGSLInterface < Test::Unit::TestCase
  include MDS::Test::BundleMatrixInterface
  
  def setup
    MDS::Matrix.push_interface(MDS::GSLInterface)
  end
  
  def teardown
    MDS::Matrix.pop_interface
  end
  
end
