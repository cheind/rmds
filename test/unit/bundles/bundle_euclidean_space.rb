#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'

#
# Module containing standarized tests for MDS::EuclideanSpace.
#
module BundleEuclideanSpace
  include MatrixAssertions

  def test_squared_distances
    input = MDS::Matrix.create_rows(
      [1.0, 2.0], 
      [4.0, 3.0],
      [0.0, 1.0]
    )
    
    output = MDS::Matrix.create_rows(
      [0.0, 10.0, 2.0], 
      [10.0, 0.0, 20.0], 
      [2.0, 20.0, 0.0]
    )
    
    d = MDS::EuclideanSpace.squared_distances(input)
    assert_equal_matrices(output, d)
  end
end
