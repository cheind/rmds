#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

begin
  require 'rbgsl'
rescue LoadError
  warn "\n**Notice: GSLAdapter requires \'rb-gsl\' which was not found."
  warn "You can install the extension from : \n http://rb-gsl.rubyforge.org/ \n"
  raise $!
end

module MDS
  
  #
  # Matrix adapter for GSL matrices.
  #
  class GSLAdapter < MatrixAdapter
    
    #
    # Create a new matrix with equal elements.
    #
    # @param (see MatrixAdapter#create)
    # @return (see MatrixAdapter#create)
    #
    def create(n, m, s)
      mat = ::GSL::Matrix.alloc(n, m)
      mat.set_all(s)
      mat
    end

    #
    # Return the number of matrix rows
    #
    # @param (see MatrixAdapter#nrows)
    # @return (see MatrixAdapter#nrows)
    #
    def nrows(m)
      m.size1
    end
    
    #
    # Return the number of matrix columns
    #
    # @param (see MatrixAdapter#ncols)
    # @return (see MatrixAdapter#ncols)
    #
    def ncols(m)
      m.size2
    end
   
    #
    # Set matrix element.
    #
    # @param (see MatrixAdapter#set)
    #
    def set(m, i, j, s)
      m[i,j] = s
    end
    
    #
    # Get matrix element.
    #
    # @param (see MatrixAdapter#get)
    # @return (see MatrixAdapter#get)
    #
    def get(m, i, j)
      m[i,j]
    end
    
    #
    # Calculate the product of two matrices or
    # the product of a matrix and a scalar.
    #
    # @param (see MatrixAdapter#prod)
    # @return (see MatrixAdapter#prod)
    #
    def prod(m, n)
      m * n
    end
    
    #
    # Transpose a matrix.
    #
    # @param (see MatrixAdapter#t)
    # @return (see MatrixAdapter#t)
    #
    def t(m)
      m.transpose
    end
    
    #
    # Componentwise addition of two matrices.
    #
    # @param (see MatrixAdapter#add)
    # @return (see MatrixAdapter#add)
    #
    def add(m, n)
      m + n
    end
    
    #
    # Componentwise subtraction of two matrices.
    #
    # @param (see MatrixAdapter#sub)
    # @return (see MatrixAdapter#sub)
    #
    def sub(m, n)
      m - n
    end
    
    #
    # Compute the eigen-decomposition of a real symmetric matrix.
    #
    # @param (see MatrixAdapter#ed)
    # @return (see MatrixAdapter#ed)
    #
    def ed(m)
      eigen_values, eigen_vectors = ::GSL::Eigen::symmv(m)
      ::GSL::Eigen::Symmv::sort(
        eigen_values, 
        eigen_vectors, 
        ::GSL::Eigen::SORT_VAL_DESC
      )
      
      [eigen_values.to_m_diagonal, eigen_vectors]
    end
    
  end
end
