#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://code.google.com/p/mdsl/
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
    def create_random(n, m, smin, smax)
      range = smax - smin
      m = self.create_scalar(n, m, 0.0)
      for i in 0..self.nrows(m)-1
        for j in 0..self.ncols(m)-1
          self.set(m, i, j, smin + range*rand())
        end
      end
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
    
  end
end