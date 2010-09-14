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
  #   computations through methods defined in {MDS::MatrixInterface}-
  #   
  # To successfully integrate and use a linear algebra package in RMDS, 
  # the following two steps are necessary.
  #
  # * Subclass from {MDS::MatrixInterface} and implement at least all
  #   abstract class methods.
  # * Tell RMDS to use it by setting the default matrix interface.
  #
  # Subclassing is documented at {MDS::MatrixInterface}. The latter is 
  # accomplished by setting system wide interface through one of the 
  # following methods
  #  
  #  # Set active interface
  #  MDS::Matrix.interface = YourMatrixInterface
  #
  #  # Push onto interface stack and set active interface
  #  MDS::Matrix.push_interface(YourMatrixInterface)
  #
  #  # Restore the previously active interface
  #  MDS::Matrix.push_interface(YourMatrixInterface)
  #
  # @see MDS::MatrixInterface
  #
  class Matrix
    # Stores the matrix interaces to use at class level
    @mi = []
    class << self; 
      # 
      # Access the active matrix interface.
      #
      def interface; @mi.first; end
      
      #
      # Set the active matrix interface.
      #
      def interface=(i); @mi.pop; @mi.push(i); end

      #
      # Push matrix interface onto the stack and set it active.
      #      
      def push_interface(i); @mi.push(i); end
      
      #
      # Deactivate current matrix interface by popping it from stack.
      #
      def pop_interface; @mi.pop(); end
    end
  
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
      Matrix.new(Matrix.interface.create(n, m, s))
    end
    
    #
    # Create a new matrix and assign each element as the
    # result of invoking the given block.
    #
    # @param (see MatrixInterface#create_block)
    # @return [Matrix] the newly created matrix.
    #
    def Matrix.create_block(n, m, &block)
      Matrix.new(Matrix.interface.create_block(n, m, &block))
    end
    
    #
    # Create a new matrix from uniform random distribution.
    #
    # @param (see MatrixInterface#create_random)
    # @return [Matrix] the newly created matrix.
    #
    def Matrix.create_random(n, m, smin = -1.0, smax = 1.0)
      Matrix.new(Matrix.interface.create_random(n, m, smin, smax))
    end
    
    #
    # Create a new identity matrix.
    #
    # @param (see MatrixInterface#create_identity)
    # @return [Matrix] the newly created matrix.
    #
    def Matrix.create_identity(n)
      Matrix.new(Matrix.interface.create_identity(n))
    end  

    #
    # Create a new diagonal matrix.
    #
    # @param (see MatrixInterface#create_diagonal)
    # @return [Matrix] the newly created matrix.
    #
    def Matrix.create_diagonal(*elements)
      Matrix.new(Matrix.interface.create_diagonal(*elements))
    end
    
    #
    # Create matrix from rows.
    #
    # @param (see MatrixInterface#create_rows)
    # @return [Matrix] the newly created matrix.
    #
    def Matrix.create_rows(*rows)
      Matrix.new(Matrix.interface.create_rows(*rows))
    end
    
    #
    # Return the number of matrix rows
    #
    # @return number of rows in matrix
    #
    def nrows
      Matrix.interface.nrows(@m)
    end
    
    #
    # Return the number of matrix columns
    #
    # @return number of columns in matrix
    #
    def ncols
      Matrix.interface.ncols(@m)
    end
    
    #
    # Set value of matrix element.
    #
    # @param [Integer] i the i-th row, zero-based indexing
    # @param [Integer] j the j-th column, zero-based indexing
    # @param [Float] s scalar value to set
    # 
    def []=(i, j, s)
      Matrix.interface.set(@m, i, j, s)
    end
    
    #
    # Get value of matrix element.
    #
    # @param [Integer] i the i-th row, zero-based indexing
    # @param [Integer] j the j-th column, zero-based indexing
    # @return [Float] value of element
    #
    def [](i,j)
      Matrix.interface.get(@m, i, j)
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
        Matrix.interface.prod(@m, is_ma ? other.matrix : other)
      )
    end
    
    #
    # Componentwise addition of two matrices.
    #
    # @param [Matrix] other matrix to add to this matrix
    # @return [Matrix] the matrix.
    #
    def +(other)
      Matrix.new(Matrix.interface.add(@m, other.m))
    end
    
    #
    # Componentwise subtraction of two matrices.
    #
    # @param [Matrix] other matrix to subtract from this matrix.
    # @return [Matrix] the matrix.
    #
    def -(other)
      Matrix.new(Matrix.interface.sub(@m, other.m))
    end
    
    #
    # Transpose a matrix.
    #
    # @return [Matrix] the transposed matrix.
    #
    def t
      Matrix.new(Matrix.interface.t(@m))
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
      Matrix.interface.ed(@m).map {|m| Matrix.new(m) }
    end
    
    #
    # Retrieve the diagonal elements as an array.
    #
    # @return [Array] diagonal elements as array.
    #
    def diagonals
      Matrix.interface.diagonals(@m)
    end
    
    #
    # Calculate the sum of diagonal matrix elements.
    #
    # @return [Float] trace of matrix
    #
    def trace
      Matrix.interface.trace(@m)
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
        Matrix.interface.minor(@m, row_range, col_range)
      )
    end
    
  end
end
