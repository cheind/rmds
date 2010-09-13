#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'
require 'mds/adapters/gsl_adapter'

class TestClassicGSL < Test::Unit::TestCase
  include MatrixAssertions
  
  def test_2d
    x = ::GSL::Matrix[
      [1.0, 2.0], 
      [4.0, 3.0],
      [0.0, 1.0]
    ]
    
    ma = MDS::GSLAdapter.new
    d = MDS.l2_distances_squared(ma, x)
    proj = MDS::Classic.project(ma, d, 0.99)
    d_proj = MDS.l2_distances_squared(ma, proj)    
    assert_delta_matrices(ma, d, d_proj, 1e-5)
  end
  
  def test_5d
    ma = MDS::GSLAdapter.new
    x = ma.create_random(15, 5, -10, 10)
    d = MDS.l2_distances_squared(ma, x)
    proj = MDS::Classic.project(ma, d, 0.99)
    d_proj = MDS.l2_distances_squared(ma, proj)
    assert_delta_matrices(ma, d, d_proj, 1e-5)
  end

end
