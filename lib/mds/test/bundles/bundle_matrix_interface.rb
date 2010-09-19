#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require 'mds/test/matrix_assertions.rb'

module MDS
  module Test
  
    #
    # Module containing standarized tests for matrix interfaces.
    #
    module BundleMatrixInterface
      include MDS::Test::MatrixAssertions

      #----------------------------
      # Matrix creators
      #----------------------------

      def test_create
        m = MDS::Matrix.create(2, 3, 0.0)
        assert_equal(2, m.nrows)
        assert_equal(3, m.ncols)
        
        for i in 0..m.nrows-1 do
          for j in 0..m.ncols-1 do
            assert_instance_of(Float, m[i,j])
            assert_equal(0.0, m[i,j])
          end
        end
      end
      
      def test_create_identity
        m = MDS::Matrix.create_identity(3)
        r = MDS::Matrix.create(3, 3, 0.0)
        r[0,0] = 1.0; r[1,1] = 1.0; r[2,2] = 1.0;
        assert_equal_matrices(m, r)
      end
      
      def test_create_diagonal
        m = MDS::Matrix.create_diagonal(1.0, 2.0, 3.0)
        r = MDS::Matrix.create(3, 3, 0.0)
        r[0,0] = 1.0; r[1,1] = 2.0; r[2,2] = 3.0;
        assert_equal_matrices(m, r)
      end
      
      def test_create_block
        m = MDS::Matrix.create_block(2,2) do |i,j|
          i == j ? 0.0 : 1.0
        end
        r = MDS::Matrix.create(3, 3, 1.0)
        r[0,0] = 0.0; r[1,1] = 0.0;
        assert_equal_matrices(m, r)
      end
      
      def test_create_rows
        m = MDS::Matrix.create_rows([1.0, 2.0, 3.0], [4.0, 5.0, 6.0])
        r = MDS::Matrix.create_block(2,3) do |i,j|
          (i*3 + j + 1).to_f
        end
        assert_equal_matrices(m, r)
      end
      
      #----------------------------
      # Matrix element accessors
      #----------------------------
      
      def test_get_set
        a = MDS::Matrix.create(2, 2, 1.0)

        a[0,0] = 1.0
        a[0,1] = 2.0
        a[1,0] = 3.0
        a[1,1] = 4.0
            
        assert_equal(1.0, a[0,0])
        assert_equal(2.0, a[0,1])
        assert_equal(3.0, a[1,0])
        assert_equal(4.0, a[1,1])
      end
      
      #----------------------------
      # Matrix views
      #----------------------------
      
      def test_transpose
        a = MDS::Matrix.create_rows([2.0, 3.0, 4.0], [1.0, 2.0, 3.0])
        r = MDS::Matrix.create_rows([2.0, 1.0], [3.0, 2.0], [4.0, 3.0])
        m = a.t
        assert_delta_matrices(r, m)
      end
      
      def test_diagonals
        a = MDS::Matrix.create_rows([2.0, 3.0, 4.0], [1.0, 4.0, 3.0])
        r = MDS::Matrix.create_rows([2.0, 4.0])
        m = MDS::Matrix.create_rows(a.diagonals)
        assert_delta_matrices(r, m)
      end
      
      def test_minor
        a = MDS::Matrix.create_rows([2.0, 3.0, 4.0], [1.0, 4.0, 3.0])
        r = MDS::Matrix.create_rows([4.0],[3.0])
        m = a.minor(0..1, 2..2)
        assert_delta_matrices(r, m)
      end
      
      def test_trace
        a = MDS::Matrix.create_rows([2.0, 3.0, 4.0], [1.0, 4.0, 3.0])
        assert_equal(6.0, a.trace)
      end
      
      def test_columns
        a = MDS::Matrix.create_rows([2.0, 3.0, 4.0], [1.0, 4.0, 3.0])
        assert_equal([[2.0, 1.0], [3.0, 4.0], [4.0, 3.0]], a.columns)
      end
      
      #----------------------------
      # Matrix operations
      #----------------------------
      
      def test_product
        a = MDS::Matrix.create_rows([2.0, 3.0, 4.0], [1.0, 2.0, 3.0])
        b = MDS::Matrix.create_rows([3.0, 1.0], [1.0, 2.0], [3.0, -4.0])
        r = MDS::Matrix.create_rows([21.0, -8.0], [14.0, -7.0])
        
        m = a * b
        assert_delta_matrices(r, m)
      end
      
      def test_product_scalar
        a = MDS::Matrix.create_rows([2.0, 3.0, 4.0], [1.0, 2.0, 3.0])
        r = MDS::Matrix.create_rows([4.0, 6.0, 8.0], [2.0, 4.0, 6.0])
        m = a * 2.0
        assert_delta_matrices(r, m)
      end
      
      def test_add
        a = MDS::Matrix.create_rows([2.0, 3.0, 4.0], [1.0, 2.0, 3.0])
        b = MDS::Matrix.create_rows([1.0, 2.0, 3.0], [0.0, 0.0, 2.0])
        r = MDS::Matrix.create_rows([3.0, 5.0, 7.0], [1.0, 2.0, 5.0])
        m = a + b
        assert_delta_matrices(r, m)
      end
      
      def test_sub
        a = MDS::Matrix.create_rows([2.0, 3.0, 4.0], [1.0, 2.0, 3.0])
        b = MDS::Matrix.create_rows([1.0, 2.0, 2.0], [0.0, 0.0, 2.0])
        r = MDS::Matrix.create_rows([1.0, 1.0, 2.0], [1.0, 2.0, 1.0])
        m = a - b
        assert_delta_matrices(r, m)
      end
        
      def test_ed
        a = MDS::Matrix.create_rows(
          [0.0, 10.0, 2.0], 
          [10.0, 0.0, 20.0],
          [2.0, 20.0, 0.0]
        )
                
        eval_a, evec_a = a.ed
        
        assert_in_delta(23.2051, eval_a[0,0], 1e-3)
        assert_in_delta(-1.5954, eval_a[1,1], 1e-3)
        assert_in_delta(-21.6097, eval_a[2,2], 1e-3)
          
        r0 = MDS::Matrix.create_rows([0.3529, 0.6934, 0.6281])
        r1 = MDS::Matrix.create_rows([0.8948, -0.0541, -0.4430])
        r2 = MDS::Matrix.create_rows([-0.2732, 0.7184, -0.6396])
        
        v0 = evec_a.minor(0..2, 0..0)
        v1 = evec_a.minor(0..2, 1..1)
        v2 = evec_a.minor(0..2, 2..2)
        
        # Norm of vectors
        assert_in_delta(1.0, (v0.t * v0)[0,0], 1e-3)
        assert_in_delta(1.0, (v1.t * v1)[0,0], 1e-3)
        assert_in_delta(1.0, (v2.t * v2)[0,0], 1e-3)
        
        # Orthogonality of basis vectors
        assert_in_delta(0.0, (v0.t * v1)[0,0], 1e-3)
        assert_in_delta(0.0, (v0.t * v2)[0,0], 1e-3)
        assert_in_delta(0.0, (v1.t * v2)[0,0], 1e-3)
        
        # Orientation of basis vectors (up to 180° ambiguity)
        assert_in_delta(1.0, (r0 * v0)[0,0].abs, 1e-3)
        assert_in_delta(1.0, (r1 * v1)[0,0].abs, 1e-3)
        assert_in_delta(1.0, (r2 * v2)[0,0].abs, 1e-3)
      end
    end
    
  end
end
