#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require 'mds/matrix_interface'

begin
  require 'rbgsl'
rescue LoadError
  warn "\n**Notice: GSLAdapter requires \'rb-gsl\' which was not found."
  warn "You can install the extension from : \n http://rb-gsl.rubyforge.org/ \n"
  raise $!
end

module MDS
  
  #
  # Common matrix interface for GSL types.
  #
  class GSLInterface < MatrixInterface
    
    #
    # Create a new matrix with equal elements.
    #
    # @param (see MatrixInterface#create)
    # @return (see MatrixInterface#create)
    #
    def GSLInterface.create(n, m, s)
      mat = ::GSL::Matrix.alloc(n, m)
      mat.set_all(s)
      mat
    end

    #
    # Return the number of matrix rows
    #
    # @param (see MatrixInterface#nrows)
    # @return (see MatrixInterface#nrows)
    #
    def GSLInterface.nrows(m)
      m.size1
    end
    
    #
    # Return the number of matrix columns
    #
    # @param (see MatrixInterface#ncols)
    # @return (see MatrixInterface#ncols)
    #
    def GSLInterface.ncols(m)
      m.size2
    end
   
    #
    # Set matrix element.
    #
    # @param (see MatrixInterface#set)
    #
    def GSLInterface.set(m, i, j, s)
      m[i,j] = s
    end
    
    #
    # Get matrix element.
    #
    # @param (see MatrixInterface#get)
    # @return (see MatrixInterface#get)
    #
    def GSLInterface.get(m, i, j)
      m[i,j]
    end
    
    #
    # Calculate the product of two matrices or
    # the product of a matrix and a scalar.
    #
    # @param (see MatrixInterface#prod)
    # @return (see MatrixInterface#prod)
    #
    def GSLInterface.prod(m, n)
      m * n
    end
    
    #
    # Transpose a matrix.
    #
    # @param (see MatrixInterface#t)
    # @return (see MatrixInterface#t)
    #
    def GSLInterface.t(m)
      m.transpose
    end
    
    #
    # Componentwise addition of two matrices.
    #
    # @param (see MatrixInterface#add)
    # @return (see MatrixInterface#add)
    #
    def GSLInterface.add(m, n)
      m + n
    end
    
    #
    # Componentwise subtraction of two matrices.
    #
    # @param (see MatrixInterface#sub)
    # @return (see MatrixInterface#sub)
    #
    def GSLInterface.sub(m, n)
      m - n
    end
    
    #
    # Compute the eigen-decomposition of a real symmetric matrix.
    #
    # @param (see MatrixInterface#ed)
    # @return (see MatrixInterface#ed)
    #
    def GSLInterface.ed(m)
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
