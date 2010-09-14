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
  # @param [MatrixAdapter] a first matrix
  # @param [MatrixAdapter] second matrix
  #
  def assert_equal_matrices(a, b)
    assert_instance_of(a.matrix.class, b.matrix)
    assert_equal(a.interface, b.interface)
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
  # @param [MatrixAdapter] first matrix
  # @param [MatrixAdapter] second matrix
  # @param [Float] delta delta
  #
  def assert_delta_matrices(a, b, delta = 1e-10)
    assert_instance_of(a.matrix.class, b.matrix)
    assert_equal(a.interface, b.interface)
    assert(a.nrows, b.nrows)
    assert(a.ncols, b.ncols)
    
    for i in 0..a.nrows-1 do
      for j in 0..a.ncols-1 do
        assert_in_delta(a[i,j], b[i,j], delta)
      end
    end
  end
end

module AutoTestMatrixInterface
  include MatrixAssertions

  def test_create_scalar
    m = @ma.create(2, 3, 0.0)
    assert_instance_of(Matrix, m)
    assert_equal(2, @ma.nrows(m))
    assert_equal(3, @ma.ncols(m))
    
    for i in 0..m.row_size-1 do
      for j in 0..m.column_size-1 do
        assert_instance_of(Float, m[i,j])
        assert_equal(0.0, m[i,j])
      end
    end
  end
  
  def test_get_set
    a = @ma.create(2, 2, 1.0)
    @ma.set(a, 0, 0, 1.0)
    @ma.set(a, 0, 1, 2.0)
    @ma.set(a, 1, 0, 3.0)
    @ma.set(a, 1, 1, 4.0)
    
    assert_equal(1.0, @ma.get(a, 0, 0))
    assert_equal(2.0, @ma.get(a, 0, 1))
    assert_equal(3.0, @ma.get(a, 1, 0))
    assert_equal(4.0, @ma.get(a, 1, 1))
  end
  
  def test_prod
    a = @ma.create_random(2, 3)
    b = @ma.create_random(3, 2)
    
    r = @ma.prod(a,b)
    g = a * b
    assert_equal_matrices(MDS::MatrixAdapter.new(r, @ma), MDS::MatrixAdapter.new(g, @ma))
        
    r = @ma.prod(a, 2.0)
    g = a * 2.0
    assert_equal_matrices(MDS::MatrixAdapter.new(r, @ma), MDS::MatrixAdapter.new(g, @ma))
  end
  
  def test_add
    a = @ma.create_random(2, 3)
    b = @ma.create_random(2, 3)
    
    r = @ma.add(a, b)
    g = a + b
    assert_equal_matrices(MDS::MatrixAdapter.new(r, @ma), MDS::MatrixAdapter.new(g, @ma))
  end
  
  def test_sub
    a = @ma.create_random(2, 3)
    b = @ma.create_random(2, 3)
    
    r = @ma.sub(a, b)
    g = a - b
    assert_equal_matrices(MDS::MatrixAdapter.new(r, @ma), MDS::MatrixAdapter.new(g, @ma))
  end
  
  def test_t
    a = @ma.create_random(2, 3)
    t = @ma.t(a)
    assert_equal_matrices(MDS::MatrixAdapter.new(t, @ma), MDS::MatrixAdapter.new(a.t, @ma))
  end
    
  def test_ed
    a = @ma.create(3, 3, 0.0)

    a[0,0] = 0.0; a[0,1] = 10.0; a[0,2] = 2.0;
    a[1,0] = 10.0; a[1,1] = 0.0; a[1,2] = 20.0;
    a[2,0] = 2.0; a[2,1] = 20.0; a[2,2] = 0.0;
        
    eval_a, evec_a = @ma.ed(a)
    
    assert_in_delta(23.2051, eval_a[0,0], 1e-3)
    assert_in_delta(-1.5954, eval_a[1,1], 1e-3)
    assert_in_delta(-21.6097, eval_a[2,2], 1e-3)
    
    assert_in_delta(0.3529, evec_a[0,0], 1e-3)
    assert_in_delta(0.6934, evec_a[1,0], 1e-3)
    assert_in_delta(0.6281, evec_a[2,0], 1e-3)
    
    assert_in_delta( 0.8948, evec_a[0,1], 1e-3)
    assert_in_delta(-0.0541, evec_a[1,1], 1e-3)
    assert_in_delta(-0.4430, evec_a[2,1], 1e-3)

    assert_in_delta(-0.2732, evec_a[0,2], 1e-3)
    assert_in_delta( 0.7184, evec_a[1,2], 1e-3)
    assert_in_delta(-0.6396, evec_a[2,2], 1e-3)
    
=begin Octave yields
    eigen_vecs =

      -0.273269   0.894836  -0.352977
       0.718455  -0.054138  -0.693463
      -0.639646  -0.443100  -0.628105

    eigen_vals =

    Diagonal Matrix

      -21.6097         0         0
             0   -1.5954         0
             0         0   23.2051
=end
  end
end

class Matrix
  #
  # Set element
  #
  def []=(i, j, x)
    @rows[i][j] = x
  end
end
