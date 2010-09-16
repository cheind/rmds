#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#


#
# Addition assertions for comparing matrices.
#
module MatrixAssertions

  #
  # Assert that two matrices are equal
  #
  # @param [MDS::Matrix] a first matrix
  # @param [MDS::Matrix] b second matrix
  #
  def assert_equal_matrices(a, b)
    assert_instance_of(a.matrix.class, b.matrix)
    assert(a.nrows, b.nrows)
    assert(a.ncols, b.ncols)
    
    for i in 0..a.nrows-1 do
      for j in 0..a.ncols-1 do
        assert_equal(a[i,j], b[i,j])
      end
    end
  end
  
  #
  # Assert that two matrices are equal up to delta
  #
  # @param [MDS::Matrix] first matrix
  # @param [MDS::Matrix] second matrix
  # @param [Float] delta delta
  #
  def assert_delta_matrices(a, b, delta = 1e-10)
    assert_instance_of(a.matrix.class, b.matrix)
    assert(a.nrows, b.nrows)
    assert(a.ncols, b.ncols)
    
    for i in 0..a.nrows-1 do
      for j in 0..a.ncols-1 do
        assert_in_delta(a[i,j], b[i,j], delta)
      end
    end
  end
end
