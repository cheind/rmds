#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

module MDS
  
  #
  # Wraps matrices and MatrixInterfaces to provide
  # an easy to access adapter.
  #
  class MatrixAdapter
    # Wrapped matrix
    attr_reader :matrix
    # MatrixInterface
    attr_reader :interface
    
    #
    # Initialize from matrix instance and interface class.
    #
    # @param matrix the matrix to be wrapped
    # @param [MatrixInterface] the interface class
    #
    def initialize(matrix, interface)
      @matrix = matrix
      @interface = interface
    end 
    
    #
    # Return the number of matrix rows
    #
    # @return number of rows in matrix
    #
    def nrows
      @interface.nrows(@matrix)
    end
    
    #
    # Return the number of matrix columns
    #
    # @return number of columns in matrix
    #
    def ncols
      @interface.ncols(@matrix)
    end
    
    #
    # Set value of matrix element.
    #
    # @param [Integer] i the i-th row, zero-based indexing
    # @param [Integer] j the j-th column, zero-based indexing
    # @param [Float] s scalar value to set
    # 
    def []=(i, j, s)
      @interface.set(@matrix, i, j, s)
    end
    
    #
    # Get value of matrix element.
    #
    # @param [Integer] i the i-th row, zero-based indexing
    # @param [Integer] j the j-th column, zero-based indexing
    # @return [Float] value of element
    #
    def [](i,j)
      @interface.get(@matrix, i, j)
    end
    
    #
    # Calculate the product of two matrices or
    # the product of a matrix and a scalar.
    #
    # @param [MatrixAdapter, Float] other matrix to multiply with, or scalar
    # @return [MatrixAdapter] the matrix.
    #
    def *(other)
      is_ma = other.instance_of?(MatrixAdapter)
      MatrixAdapter.new(
        @interface.prod(@matrix, is_ma ? other.matrix : other), 
        @interface)
    end
    
    #
    # Componentwise addition of two matrices.
    #
    # @param [MatrixAdapter] other matrix to add to this matrix
    # @return [MatrixAdapter] the matrix.
    #
    def +(other)
      MatrixAdapter.new(@interface.add(@matrix, other.matrix), @interface)
    end
    
    #
    # Componentwise subtraction of two matrices.
    #
    # @param [MatrixAdapter] other matrix to subtract from this matrix.
    # @return [MatrixAdapter] the matrix.
    #
    def -(other)
      MatrixAdapter.new(@interface.sub(@matrix, other.matrix), @interface)
    end
    
    #
    # Transpose a matrix.
    #
    # @return [MatrixAdapter] the transposed matrix.
    #
    def t
      MatrixAdapter.new(@interface.t(@matrix), @interface)
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
      @interface.ed(@matrix).map {|m| MatrixAdapter.new(m, @interface) }
    end
    
    #
    # Retrieve the diagonal elements as an array.
    #
    # @return [Array] diagonal elements as array.
    #
    def diagonals
      @interface.diagonals(@matrix)
    end
    
    #
    # Calculate the sum of diagonal matrix elements.
    #
    # @return [Float] trace of matrix
    #
    def trace
      @interface.trace(@matrix)
    end
    
    #
    # Calculate minor matrix.
    #
    # @param [Range] row_range row range
    # @param [Range] col_range column range
    # @return [MatrixAdapter] minor matrix
    #
    def minor(row_range, col_range)
      MatrixAdapter.new(@interace.minor(@matrix, row_range, col_range), @interface)
    end
    
  end
end
