#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

module MDS
  
  #
  # A matrix adapter.
  #
  # RMDS does not implement matrices or linear algebra routines itself, 
  # instead RMDS offers a non-intrusive adapter architecture to interop 
  # with third party linear algebra packages.
  #
  # The RMDS adapter architecture consists of two layers
  #
  # * {MDS::MatrixInterface} defines a minimal common interface of 
  #   required interop methods.
  # * {MDS::Matrix} is a matrix adapter that binds to data provided by 
  #   a specialized {MDS::MatrixInterface} class and carries out all
  #   computations through methods defined in {MDS::MatrixInterface}.
  #
  # @see MDS::MatrixInterface
  #
  class Matrix 
    # Wrapped matrix
    attr_reader :m
    alias :matrix :m
    
    #
    # Initialize from matrix instance and interface class.
    #
    # @param matrix the matrix to be wrapped
    #
    def initialize(matrix)
      @m = matrix
    end
    
    # 
    # Create a new matrix setting all elements to equal values.
    #
    # @param (see MatrixInterface#create)
    # @return [Matrix] the newly created matrix.
    #
    def Matrix.create(n, m, s)
      Matrix.new(Backend.active.create(n, m, s))
    end
    
    #
    # Create a new matrix and assign each element as the
    # result of invoking the given block.
    #
    # @param (see MatrixInterface#create_block)
    # @return [Matrix] the newly created matrix.
    #
    def Matrix.create_block(n, m, &block)
      Matrix.new(Backend.active.create_block(n, m, &block))
    end
    
    #
    # Create a new matrix from uniform random distribution.
    #
    # @param (see MatrixInterface#create_random)
    # @return [Matrix] the newly created matrix.
    #
    def Matrix.create_random(n, m, smin = -1.0, smax = 1.0)
      Matrix.new(Backend.active.create_random(n, m, smin, smax))
    end
    
    #
    # Create a new identity matrix.
    #
    # @param (see MatrixInterface#create_identity)
    # @return [Matrix] the newly created matrix.
    #
    def Matrix.create_identity(n)
      Matrix.new(Backend.active.create_identity(n))
    end  

    #
    # Create a new diagonal matrix.
    #
    # @param (see MatrixInterface#create_diagonal)
    # @return [Matrix] the newly created matrix.
    #
    def Matrix.create_diagonal(*elements)
      Matrix.new(Backend.active.create_diagonal(*elements))
    end
    
    #
    # Create matrix from rows.
    #
    # @param (see MatrixInterface#create_rows)
    # @return [Matrix] the newly created matrix.
    #
    def Matrix.create_rows(*rows)
      Matrix.new(Backend.active.create_rows(*rows))
    end
    
    #
    # Return the number of matrix rows
    #
    # @return number of rows in matrix
    #
    def nrows
      Backend.active.nrows(@m)
    end
    
    #
    # Return the number of matrix columns
    #
    # @return number of columns in matrix
    #
    def ncols
      Backend.active.ncols(@m)
    end
    
    #
    # Set value of matrix element.
    #
    # @param [Integer] i the i-th row, zero-based indexing
    # @param [Integer] j the j-th column, zero-based indexing
    # @param [Float] s scalar value to set
    # 
    def []=(i, j, s)
      Backend.active.set(@m, i, j, s)
    end
    
    #
    # Get value of matrix element.
    #
    # @param [Integer] i the i-th row, zero-based indexing
    # @param [Integer] j the j-th column, zero-based indexing
    # @return [Float] value of element
    #
    def [](i,j)
      Backend.active.get(@m, i, j)
    end
    
    #
    # Calculate the product of two matrices or
    # the product of a matrix and a scalar.
    #
    # @param [Matrix, Float] other matrix to multiply with, or scalar
    # @return [Matrix] the matrix.
    #
    def *(other)
      is_ma = other.instance_of?(Matrix)
      Matrix.new(
        Backend.active.prod(@m, is_ma ? other.matrix : other)
      )
    end
    
    #
    # Componentwise addition of two matrices.
    #
    # @param [Matrix] other matrix to add to this matrix
    # @return [Matrix] the matrix.
    #
    def +(other)
      Matrix.new(Backend.active.add(@m, other.m))
    end
    
    #
    # Componentwise subtraction of two matrices.
    #
    # @param [Matrix] other matrix to subtract from this matrix.
    # @return [Matrix] the matrix.
    #
    def -(other)
      Matrix.new(Backend.active.sub(@m, other.m))
    end
    
    #
    # Transpose a matrix.
    #
    # @return [Matrix] the transposed matrix.
    #
    def t
      Matrix.new(Backend.active.t(@m))
    end
    
    #
    # Compute the eigen-decomposition of a real symmetric matrix.
    #
    # The eigen-decomposition consists of a diagonal matrix +D+ containing
    # the eigen values and a square matrix +N+ having the normalized eigenvectors
    # in columns. 
    #
    # @return [Array] the array containing the matrix of eigen-values and eigen-vector
    #
    def ed
      Backend.active.ed(@m).map {|m| Matrix.new(m) }
    end
    
    #
    # Retrieve the diagonal elements as an array.
    #
    # @return [Array] diagonal elements as array.
    #
    def diagonals
      Backend.active.diagonals(@m)
    end
    
    #
    # Calculate the sum of diagonal matrix elements.
    #
    # @return [Float] trace of matrix
    #
    def trace
      Backend.active.trace(@m)
    end
    
    #
    # Calculate minor matrix.
    #
    # @param [Range] row_range row range
    # @param [Range] col_range column range
    # @return [Matrix] minor matrix
    #
    def minor(row_range, col_range)
      Matrix.new(
        Backend.active.minor(@m, row_range, col_range)
      )
    end
    
    #
    # Returns matrix as array of columns.
    # 
    # @return [Array<Array>] the array of columns where each column is an array
    #
    def columns
      Backend.active.columns(@m) 
    end
    
    #
    # Returns matrix as array of rows.
    # 
    # @return [Array<Array>] the array of rows where each row is an array
    #
    def rows
      Backend.active.rows(@m) 
    end
    
    #
    # Convert to string.
    #
    # Invokes #to_s from wrapped matrix.
    #
    # @return wrapped matrix as string.
    #
    def to_s
      Backend.active.to_s(@m) 
    end
    
  end
end
