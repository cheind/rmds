#
# RMDS - Ruby Multidimensional Scaling Library
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
  # Common matrix interface for the Gnu Scientific Library.
  #
  # To succesfully use this interface 'rbgsl' bindings for GSL are required.
  # For more information and installation instructions see 
  # http://rb-gsl.rubyforge.org/
  #
  class GSLInterface < MatrixInterface
    
    #
    # Create a new matrix with equal elements.
    #
    # @param (see MDS::MatrixInterface#create)
    # @return (see MDS::MatrixInterface#create)
    #
    def GSLInterface.create(n, m, s)
      mat = ::GSL::Matrix.alloc(n, m)
      mat.set_all(s)
      mat
    end

    #
    # Return the number of matrix rows
    #
    # @param (see MDS::MatrixInterface#nrows)
    # @return (see MDS::MatrixInterface#nrows)
    #
    def GSLInterface.nrows(m)
      m.size1
    end
    
    #
    # Return the number of matrix columns
    #
    # @param (see MDS::MatrixInterface#ncols)
    # @return (see MDS::MatrixInterface#ncols)
    #
    def GSLInterface.ncols(m)
      m.size2
    end
   
    #
    # Set matrix element.
    #
    # @param (see MDS::MatrixInterface#set)
    #
    def GSLInterface.set(m, i, j, s)
      m[i,j] = s
    end
    
    #
    # Get matrix element.
    #
    # @param (see MDS::MatrixInterface#get)
    # @return (see MDS::MatrixInterface#get)
    #
    def GSLInterface.get(m, i, j)
      m[i,j]
    end
    
    #
    # Calculate the product of two matrices or
    # the product of a matrix and a scalar.
    #
    # @param (see MDS::MatrixInterface#prod)
    # @return (see MDS::MatrixInterface#prod)
    #
    def GSLInterface.prod(m, n)
      m * n
    end
    
    #
    # Transpose a matrix.
    #
    # @param (see MDS::MatrixInterface#t)
    # @return (see MDS::MatrixInterface#t)
    #
    def GSLInterface.t(m)
      m.transpose
    end
    
    #
    # Componentwise addition of two matrices.
    #
    # @param (see MDS::MatrixInterface#add)
    # @return (see MDS::MatrixInterface#add)
    #
    def GSLInterface.add(m, n)
      m + n
    end
    
    #
    # Componentwise subtraction of two matrices.
    #
    # @param (see MDS::MatrixInterface#sub)
    # @return (see MDS::MatrixInterface#sub)
    #
    def GSLInterface.sub(m, n)
      m - n
    end
    
    #
    # Compute the eigen-decomposition of a real symmetric matrix.
    #
    # @param (see MDS::MatrixInterface#ed)
    # @return (see MDS::MatrixInterface#ed)
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
