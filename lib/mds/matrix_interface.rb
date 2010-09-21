#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

module MDS
  
  #
  # Provides a common interface to matrix operations.
  #
  # RMDS does not implement any linear algebra routine itself,
  # but rather provides a non intrusive mechanism to plugin third party 
  # linear algebra packages. {MDS::MatrixInterface} defines a minimal 
  # set of required methods to be implemented for any linear algebra packages
  # which are to be used with RMDS.
  #
  # Making linear algebra backends compatible with RMDS is easy:
  # simply subclass from {MDS::MatrixInterface} and implement all abstract
  # methods. Not all of {MDS::MatrixInterface} methods are abstract, some
  # come with a default implementation. If your linear algebra package
  # does better at some of those methods, you should override them in your
  # interface subclass.
  #
  # RMDS helps you in testing your matrix interfaces through test bundles
  # that ship with RMDS. Each test bundle contains a set of tests that work 
  # independently of the matrix interface chosen. The following file unit
  # tests a matrix interface.
  #
  #  require 'test/unit'
  #  require 'mds/test/bundles/bundle_matrix_interface.rb'
  #  require 'mds/interfaces/linalg_interface'
  #  
  #  class TestLinalgInteface < Test::Unit::TestCase
  #    include MDS::Test::BundleMatrixInterface
  #    
  #    def setup
  #      MDS::Backend.push_active(MDS::LinalgInterface)
  #    end
  #    
  #    def teardown
  #      MDS::Backend.pop_active
  #    end
  #    
  #  end
  #
  # Finally, tell RMDS to use your matrix interface by setting the 
  # default matrix interface, like so
  #  
  #  # Set active interface
  #  MDS::Backend.active = YourMatrixInterface
  #
  #  # Push onto interface stack and set active interface
  #  MDS::Backend.push_active(YourMatrixInterface)
  #
  #  # Restore the previously active interface
  #  MDS::Backend.pop_active
  #
  # @see MDS::Matrix, MDS::Backend
  class MatrixInterface
  
    #
    # Record creation of a subclass of this class at the MDS::Backend
    #
    def MatrixInterface.inherited(subclass)
      MDS::Backend.add(subclass)
    end
  
    #---------------------------------------
    # Required
    # Abstract methods
    #---------------------------------------
    
    # 
    # Create a new matrix having all elements equal values.
    #
    # @param [Integer] n the number of rows
    # @param [Integer] m the number of columns
    # @param [Float] s the scalar value of each matrix component
    # @return the newly created matrix.
    # @abstract
    #
    def MatrixInterface.create(n, m, s)
      raise NotImplementedError
    end
    
    #
    # Return the number of matrix rows
    #
    # @param m the matrix
    # @return number of rows in matrix
    # @abstract
    #
    def MatrixInterface.nrows(m)
      raise NotImplementedError
    end
    
    #
    # Return the number of matrix columns
    #
    # @param m the matrix
    # @return number of columns in matrix
    # @abstract
    #
    def MatrixInterface.ncols(m)
      raise NotImplementedError
    end
    
    #
    # Set value of matrix element.
    #
    # @param m the matrix
    # @param [Integer] i the i-th row, zero-based indexing
    # @param [Integer] j the j-th column, zero-based indexing
    # @param [Float] s scalar value to set
    # @abstract
    def MatrixInterface.set(m, i, j, s)
      raise NotImplementedError
    end
    
    #
    # Get value of matrix element.
    #
    # @param m the matrix
    # @param [Integer] i the i-th row, zero-based indexing
    # @param [Integer] j the j-th column, zero-based indexing
    # @return [Float] value of element
    # @abstract
    #
    def MatrixInterface.get(m, i, j)
      raise NotImplementedError
    end
    
    #
    # Calculate the product of two matrices or
    # the product of a matrix and a scalar.
    #
    # @param m first matrix
    # @param n second matrix or scalar
    # @return the matrix product as newly allocated matrix
    # @abstract
    #
    def MatrixInterface.prod(m, n)
      raise NotImplementedError
    end
    
    #
    # Componentwise addition of two matrices.
    #
    # @param m first matrix
    # @param n second matrix
    # @return the matrix addition as newly allocated matrix
    # @abstract
    def MatrixInterface.add(m, n)
      raise NotImplementedError
    end
    
    #
    # Componentwise subtraction of two matrices.
    #
    # @param m first matrix
    # @param n second matrix
    # @return the matrix subtraction as newly allocated matrix
    # @abstract
    #
    def MatrixInterface.sub(m, n)
      raise NotImplementedError
    end
    
    #
    # Transpose a matrix.
    #
    # @param m the matrix to transpose
    # @return the transposed matrix as newly allocated matrix
    # @abstract
    #
    def MatrixInterface.t(m)
      raise NotImplementedError
    end
    
    #
    # Compute the eigen-decomposition of a real symmetric matrix.
    #
    # The eigen-decomposition consists of a diagonal matrix +D+ containing
    # the eigen values and a square matrix +N+ having the normalized eigenvectors
    # in columns. It is assumed that the result of MatrixInterface#ed yields the 
    # matrices as an array and that the eigen-vectors and values are sorted in 
    # descending order of importance.
    #
    # @param m the matrix to decompose
    # @return [Array] the array containing the matrix of eigen-values and eigen-vector
    # @abstract
    #
    def MatrixInterface.ed(m)
      raise NotImplementedError
    end
    
    #---------------------------------------
    # Optional
    # Methods having default implementations.
    #---------------------------------------
    
    #
    # Create a new matrix and assign each element as the
    # result of invoking the given block.
    #
    # @param [Integer] n the number of rows
    # @param [Integer] m the number of columns.
    # @return the newly created matrix.
    #
    def MatrixInterface.create_block(n, m, &block)
      mat = self.create(n, m, 0.0)
      for i in 0..self.nrows(mat)-1
        for j in 0..self.ncols(mat)-1
          self.set(mat, i, j, block.call(i,j))
        end
      end
      mat
    end
    
    #
    # Create a new matrix with uniform random elements.
    #
    # @param [Integer] n the number of rows
    # @param [Integer] m the number of columns
    # @param [Float] smin the minimum element value (inclusive).
    # @param [Float] smax the maximum element value (inclusive).
    # @return the newly created matrix.
    #
    def MatrixInterface.create_random(n, m, smin = -1.0, smax = 1.0)
      range = smax - smin
      self.create_block(n, m) do |i,j|
        smin + range*rand()
      end
    end
    
    #
    # Create a new identity matrix.
    # 
    # @param [Integer] n matrix dimension
    # @return the newly created matrix.
    #
    def MatrixInterface.create_identity(n)
      self.create_diagonal(*[1.0]*n)
    end
    
    # 
    # Create a new diagonal matrix.
    # 
    # @param *elements the diagonal elements
    # @return the newly created matrix
    #
    def MatrixInterface.create_diagonal(*elements)
      n = elements.length
      m = self.create(n, n, 0.0)
      for i in 0..self.nrows(m)-1
        self.set(m, i, i, elements[i])
      end
      m
    end
    
    #
    # Create matrix from rows.
    #
    # @param [Array] rows the rows
    # @return the newly created matrix
    #
    def MatrixInterface.create_rows(*rows)
      nrows = rows.length

      ncols = rows.first.length
      self.create_block(nrows, ncols) do |i,j|
        rows[i][j]
      end
    end
    
    #
    # Retrieve the diagonal elements as an array.
    #
    # The number of diagonals of an NxM matrix is 
    # defined as min(N,M).
    #
    # @param m the matrix
    # @return diagonals of matrix as array.
    #
    def MatrixInterface.diagonals(m)
      size = [self.nrows(m), self.ncols(m)].min
      (0..size-1).map{|i| self.get(m,i,i)}
    end
    
    #
    # Calculate the sum of diagonal matrix elements.
    #
    # @param m the matrix
    # @return trace of matrix
    #
    def MatrixInterface.trace(m)
      self.diagonals(m).inject(0) {|sum,e| sum += e}
    end
    
    #
    # Returns matrix as array of columns.
    # 
    # @return [Array<Array>] the array of columns where each column is an array
    #
    def MatrixInterface.columns(m)
      a = Array.new(self.ncols(m)) {Array.new(self.nrows(m))}
      for i in 0..self.nrows(m)-1 do
        for j in 0..self.ncols(m)-1 do
          a[j][i] = self.get(m, i, j)
        end
      end
      a
    end
    
    #
    # Returns matrix as array of rows.
    # 
    # @return [Array<Array>] the array of rows where each rows is an array
    #
    def MatrixInterface.rows(m)
      a = Array.new(self.nrows(m)) {Array.new(self.ncols(m))}
      for i in 0..self.nrows(m)-1 do
        for j in 0..self.ncols(m)-1 do
          a[i][j] = self.get(m, i, j)
        end
      end
      a
    end
    
    #
    # Calculate minor matrix.
    #
    # @param m matrix to calculate minor from
    # @param [Range] row_range linear row range with step size equal to one.
    # @param [Range] col_range linear column range with step size equal to one.
    #
    def MatrixInterface.minor(m, row_range, col_range)
      nrows = (row_range.last - row_range.first) + 1
      ncols = (col_range.last - col_range.first) + 1
      self.create_block(nrows, ncols) do |i,j|
        self.get(m, i + row_range.first, j + col_range.first)
      end
    end
    
    #
    # Convert to string.
    #
    # Invokes #to_s from wrapped matrix.
    #
    # @return wrapped matrix as string.
    #
    def to_s(m)
      m.to_s
    end
    
  end
end
