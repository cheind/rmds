#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'test/unit'
require 'mds'

#
# Addition assertions for comparing matrices.
#
module MatrixAssertions

  #
  # Assert that two matrices are equal
  #
  # @param [MatrixAdapter] ma the matrix adapter
  # @param a first matrix
  # @param b second matrix
  #
  def assert_equal_matrices(ma, a, b)
    assert_instance_of(a.class, b)
    assert(ma.nrows(a), ma.nrows(b))
    assert(ma.ncols(a), ma.ncols(b))
    
    for i in 0..ma.nrows(a)-1 do
      for j in 0..ma.ncols(a)-1 do
        assert_equal(ma.get(a,i,j), ma.get(b,i,j))
      end
    end
  end
  
  #
  # Assert that two matrices are equal up to delta
  #
  # @param [MatrixAdapter] ma the matrix adapter
  # @param a first matrix
  # @param b second matrix
  #
  def assert_delta_matrices(ma, a, b, delta = 1e-10)
    assert_instance_of(a.class, b)
    assert(ma.nrows(a), ma.nrows(b))
    assert(ma.ncols(a), ma.ncols(b))
    
    for i in 0..ma.nrows(a)-1 do
      for j in 0..ma.ncols(a)-1 do
        assert_in_delta(ma.get(a,i,j), ma.get(b,i,j), delta)
      end
    end
  end
end


require 'matrix'

class Matrix

  #
  # Set element
  #
  def []=(i, j, x)
    @rows[i][j] = x
  end
end

module MDS
  module Test

    #
    # Test matrix adapter to avoid external dependencies in tests.
    #
    class StdMatrixAdapter < MDS::MatrixAdapter

      def create_scalar(n, m, s)
        rows = []
        n.times do
          row = []
          m.times do
            row << s
          end
          rows << row
        end
        ::Matrix[*rows]
      end

      def nrows(m)
        m.row_size
      end
      
      def ncols(m)
        m.column_size
      end
     
      def set(m, i, j, s)
        m[i,j] = s
      end
      
      def get(m, i, j)
        m[i,j]
      end
      
      def prod(m, n)
        m * n
      end
      
      def t(m)
        m.t
      end
      
      def add(m, n)
        m + n
      end
      
      def sub(m, n)
        m - n
      end
    end
    
  end
end
