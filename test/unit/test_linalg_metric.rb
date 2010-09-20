#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'
require 'mds/test/bundles/bundle_metric.rb'
require 'mds/interfaces/linalg_interface'

class TestLinalgMetric < Test::Unit::TestCase
  include MDS::Test::BundleMetric
  
  def setup
    MDS::MatrixInterface.push_interface(MDS::LinalgInterface)
  end
  
  def teardown
    MDS::MatrixInterface.pop_interface
  end
end
