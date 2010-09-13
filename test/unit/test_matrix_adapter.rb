#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'
require 'mds/adapters/ruby_adapter'

class TestMatrixAdapter < Test::Unit::TestCase
  include MatrixAssertions
  
  def setup
    @ma = MDS::Test::StdMatrixAdapter.new 
  end

  def test_create_random
    m = @ma.create_random(30, 40, -1.0, 1.0)
    assert_instance_of(Matrix, m)
    assert_equal(30, @ma.nrows(m))
    assert_equal(40, @ma.ncols(m))
    
    for i in 0..m.row_size-1 do
      for j in 0..m.column_size-1 do
        assert_instance_of(Float, m[i,j])
        assert(m[i,j] >= -1.0 && m[i,j] <= 1.0)
      end
    end
  end
  
  def test_create_identity
   m = @ma.create_identity(4)
   r = Matrix.identity(4)
   assert_equal_matrices(@ma, m, r)
  end
  
  def test_create_block
    m = @ma.create_block(2,3) do |i,j|
      (i == j ? 0.0 : 1.0)
    end
    assert_equal_matrices(@ma, m, ::Matrix[[0.0, 1.0, 1.0],[1.0, 0.0, 1.0]])
  end
  
  def test_diagonals
    m = @ma.create_identity(4)
    assert_equal([1.0,1.0,1.0,1.0], @ma.diagonals(m))
  end
  
  def test_trace
    m = @ma.create_diagonal(1.0, 2.0, 3.0, 4.0)
    assert_equal(10.0, @ma.trace(m))
  end
  
end
