#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'

class TestDistanceMatrix < Test::Unit::TestCase
  include MatrixAssertions

  def test_l2_distance_matrix
    x = ::Matrix[
      [1.0, 2.0], 
      [4.0, 3.0],
      [0.0, 1.0]
    ]
    
    ma = MDS::Test::StdMatrixAdapter.new
    d = MDS.l2_distances_squared(ma, x)

    assert_equal_matrices(
      ma, 
      ::Matrix[
        [0.0, 10.0, 2.0], 
        [10.0, 0.0, 20.0], 
        [2.0, 20.0, 0.0]], 
      d)
  end
end
