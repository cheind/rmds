#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require 'mds/matrix_interface'

begin
  require 'linalg'
rescue LoadError
  warn "\n**Notice: This matrix interface requires \'Linalg\' which was not found."
  warn "You can install the extension from: \n http://rubyforge.org/projects/linalg/ \n"
  raise $!
end

module MDS
  
  #
  # Common matrix interface for Linalg - Ruby Bindings for LAPACK.
  # 
  class LinalgInterface < MatrixInterface
    
    #
    # Create a new matrix with equal elements.
    #
    # @param (see MatrixInterface#create)
    # @return (see MatrixInterface#create)
    #
    def LinalgInterface.create(n, m, s)
      ::Linalg::DMatrix.new(n, m, s)
    end

    #
    # Return the number of matrix rows
    #
    # @param (see MatrixInterface#nrows)
    # @return (see MatrixInterface#nrows)
    #
    def LinalgInterface.nrows(m)
      m.num_rows
    end
    
    #
    # Return the number of matrix columns
    #
    # @param (see MatrixInterface#ncols)
    # @return (see MatrixInterface#ncols)
    #
    def LinalgInterface.ncols(m)
      m.num_columns
    end
   
    #
    # Set matrix element.
    #
    # @param (see MatrixInterface#set)
    #
    def LinalgInterface.set(m, i, j, s)
      m[i,j] = s
    end
    
    #
    # Get matrix element.
    #
    # @param (see MatrixInterface#get)
    # @return (see MatrixInterface#get)
    #
    def LinalgInterface.get(m, i, j)
      m[i,j]
    end
    
    #
    # Calculate the product of two matrices or
    # the product of a matrix and a scalar.
    #
    # @param (see MatrixInterface#prod)
    # @return (see MatrixInterface#prod)
    #
    def LinalgInterface.prod(m, n)
      m * n
    end
    
    #
    # Transpose a matrix.
    #
    # @param (see MatrixInterface#t)
    # @return (see MatrixInterface#t)
    #
    def LinalgInterface.t(m)
      m.transpose
    end
    
    #
    # Componentwise addition of two matrices.
    #
    # @param (see MatrixInterface#add)
    # @return (see MatrixInterface#add)
    #
    def LinalgInterface.add(m, n)
      m + n
    end
    
    #
    # Componentwise subtraction of two matrices.
    #
    # @param (see MatrixInterface#sub)
    # @return (see MatrixInterface#sub)
    #
    def LinalgInterface.sub(m, n)
      m - n
    end
    
    #
    # Compute the eigen-decomposition of a real symmetric matrix.
    #
    # @param (see MatrixInterface#ed)
    # @return (see MatrixInterface#ed)
    #
    def LinalgInterface.ed(m)
      evecs, real, img = m.eigensystem         
      [Linalg::DMatrix.diagonal(real), evecs]
    end
    
    #---------------------------------------
    # Optional
    # Methods having default implementations.
    #---------------------------------------
    
    #
    # Calculate minor matrix.
    #
    # @param (see MatrixInterface#minor)
    # @return (see MatrixInterface#minor)
    #
    def LinalgInterface.minor(m, row_range, col_range)
      nrows = (row_range.last - row_range.first) + 1
      ncols = (col_range.last - col_range.first) + 1
      m.minor(row_range.first, col_range.first, nrows, ncols)
    end
    
  end
end
