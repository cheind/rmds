#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

module MDS
  
  #
  # Provides a common interface to matrix operations.
  # Allows a non-intrusive exchange of matrix classes
  #
  class MatrixAdapter
    
    # 
    # Create a new matrix with equal elements.
    #
    # @param [Integer] n the number of rows
    # @param [Integer] m the number of columns
    # @param [Float] s the scalar value of each matrix component
    # @return the newly created matrix.
    # @abstract
    #
    def create_scalar(n, m, s)
      raise NotImplementedError
    end
    
    #
    # Create a new matrix and assign each element as the
    # result of invoking the given block.
    #
    # Default implementation uses #create_scalar
    # to allocate the matrix and invoked #set for
    # each element. Additionally #nrows and #ncols
    # are used for iteration.
    #
    # @param [Integer] n the number of rows
    # @param [Integer] m the number of columns.
    # @return the newly created matrix.
    #
    def create_block(n, m, &block)
      mat = self.create_scalar(n, m, 0.0)
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
    # Default implementation invokes MatrixAdapter#create_scalar and
    # sets elements individually.
    #
    # @param [Integer] n the number of rows
    # @param [Integer] m the number of columns
    # @param [Float] smin the minimum element value (inclusive).
    # @param [Float] smax the maximum element value (inclusive).
    # @return the newly created matrix.
    #
    def create_random(n, m, smin = -1.0, smax = 1.0)
      range = smax - smin
      m = self.create_scalar(n, m, 0.0)
      for i in 0..self.nrows(m)-1
        for j in 0..self.ncols(m)-1
          self.set(m, i, j, smin + range*rand())
        end
      end
      m
    end
    
    #
    # Create a new identity matrix.
    #
    # Default implementation invokes MatrixAdapter#create_diagonal.
    # 
    # @param [Integer] n matrix dimension
    # @return the newly created matrix.
    #
    def create_identity(n)
      self.create_diagonal(*[1.0]*n)
    end
    
    # 
    # Create a new diagonal matrix.
    # 
    # Default implementation invokes MatrixAdapter#create_scalar and
    # sets diagonal elements through MatrixAdapter#set.
    #
    def create_diagonal(*elements)
      n = elements.length
      m = self.create_scalar(n, n, 0.0)
      for i in 0..self.nrows(m)-1
        self.set(m, i, i, elements[i])
      end
      m
    end
    
    #
    # Return the number of matrix rows
    #
    # @param m the matrix
    # @return number of rows in matrix
    # @abstract
    #
    def nrows(m)
      raise NotImplementedError
    end
    
    #
    # Return the number of matrix columns
    #
    # @param m the matrix
    # @return number of columns in matrix
    # @abstract
    #
    def ncols(m)
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
    def set(m, i, j, s)
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
    def get(m, i, j)
      raise NotImplementedError
    end
    
    #
    # Calculate the product of two matrices or
    # the product of a matrix and a scalar.
    #
    # @param m first matrix of size NxM
    # @param n second matrix of size MxK or scalar
    # @return NxK matrix if second parameter is matrix, NxM matrix otherwise.
    # @abstract
    #
    def prod(m, n)
      raise NotImplementedError
    end
    
    #
    # Componentwise addition of two matrices.
    #
    # @param m first matrix of size NxM
    # @param n second matrix of size NxM
    # @return NxM matrix
    # @abstract
    #
    def add(m, n)
      raise NotImplementedError
    end
    
    #
    # Componentwise subtraction of two matrices.
    #
    # @param m first matrix of size NxM
    # @param n second matrix of size NxM
    # @return NxM matrix
    # @abstract
    #
    def sub(m, n)
      raise NotImplementedError
    end
    
    #
    # Transpose a matrix.
    #
    # @param m matrix to transpose of size NxM
    # @return transposed matrix of size MxN
    # @abstract
    #
    def t(m)
      raise NotImplementedError
    end
    
    #
    # Compute the eigen-decomposition of a real symmetric matrix.
    #
    # The eigen-decomposition consists of a diagonal matrix +D+ containing
    # the eigen values and a square matrix +N+ having the normalized eigenvectors
    # in columns. It is assumed that the result of MatrixAdapter#ed yields the 
    # matrices as an array and that the eigen-vectors and values are sorted in 
    # descending order of importance.
    #
    # @param m the matrix to decompose
    # @return [Array] the array containing the matrix of eigen-values and eigen-vectors.
    # @abstract
    #
    def ed(m)
      raise NotImplementedError
    end
    
    #
    # Retrieve the diagonal elements as an array.
    #
    # Default implementation uses MatrixAdapter#nrows, MatrixAdapter#ncols
    # and MatrixAdapter#get to retrieve elements
    #
    def diagonals(m)
      size = [self.nrows(m), self.ncols(m)].min
      (0..size-1).map{|i| self.get(m,i,i)}
    end
    
    #
    # Calculate the sum of diagonal matrix elements.
    #
    # Default implementation invokes MatrixAdapter#diagonals to
    # calculate the trace.
    #
    # @param m the matrix
    # @return trace of matrix
    #
    def trace(m)
      self.diagonals(m).inject(0) {|sum,e| sum += e}
    end
    
    #
    # Calculate minor matrix.
    #
    # Default implementation allocates a new matrix and
    # set its elements through MatrixAdapter#create_block.
    #
    # @param m matrix to calculate minor from
    # @param [Range] row_range row range
    # @param [Range] col_range column range
    #
    def minor(m, row_range, col_range)
      nrows = (row_range.last - row_range.first) + 1
      ncols = (col_range.last - col_range.first) + 1
      self.create_block(nrows, ncols) do |i,j|
        self.get(m, i + row_range.first, j + col_range.first)
      end
    end
    
  end
end
