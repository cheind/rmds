#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'test/unit'
require 'mds'

module MatrixAssertions

  #
  # Assert that two matrices are equal
  #
  # @param [MatrixAdapter] ma the matrix adapter
  # @param a first matrix
  # @param b second matrix
  #
  def assert_equal_matrices?(ma, a, b)
    assert_instance_of(a.class, b)
    assert(ma.nrows(a), ma.nrows(b))
    assert(ma.ncols(a), ma.ncols(b))
    
    for i in 0..ma.nrows(a)-1 do
      for j in 0..ma.ncols(a)-1 do
        assert_equal(ma.get(a,i,j), ma.get(b,i,j))
      end
    end
  end
  
end
