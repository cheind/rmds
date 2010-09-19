#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'
require './test/unit/bundles/bundle_metric.rb'
require 'mds/interfaces/linalg_interface'

class TestLinalgMetric < Test::Unit::TestCase
  include BundleMetric
  
  def setup
    MDS::Matrix.push_interface(MDS::LinalgInterface)
  end
  
  def teardown
    MDS::Matrix.pop_interface
  end
end
