#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require 'mds/matrix_interface'

begin
  require 'rubygems'
  require 'extendmatrix'
rescue LoadError
  warn "\n**Notice: RubyAdapter requires \'extendmatrix\' which was not found."
  warn "You can install the extension as follows: \n gem install extendmatrix \n"
  raise $!
end

module MDS
  
  #
  # Common matrix interface for Ruby's standard library Matrix class.
  #
  class StdlibInterface < MatrixInterface
    
    #
    # Create a new matrix with equal elements.
    #
    # @param (see MatrixInterface#create)
    # @return (see MatrixInterface#create)
    #
    def StdlibInterface.create(n, m, s)
      ::Matrix.build(n, m, s)
    end

    #
    # Return the number of matrix rows
    #
    # @param (see MatrixInterface#nrows)
    # @return (see MatrixInterface#nrows)
    #
    def StdlibInterface.nrows(m)
      m.row_size
    end
    
    #
    # Return the number of matrix columns
    #
    # @param (see MatrixInterface#ncols)
    # @return (see MatrixInterface#ncols)
    #
    def StdlibInterface.ncols(m)
      m.column_size
    end
   
    #
    # Set matrix element.
    #
    # @param (see MatrixInterface#set)
    #
    def StdlibInterface.set(m, i, j, s)
      m[i,j] = s
    end
    
    #
    # Get matrix element.
    #
    # @param (see MatrixInterface#get)
    # @return (see MatrixInterface#get)
    #
    def StdlibInterface.get(m, i, j)
      m[i,j]
    end
    
    #
    # Calculate the product of two matrices or
    # the product of a matrix and a scalar.
    #
    # @param (see MatrixInterface#prod)
    # @return (see MatrixInterface#prod)
    #
    def StdlibInterface.prod(m, n)
      m * n
    end
    
    #
    # Transpose a matrix.
    #
    # @param (see MatrixInterface#t)
    # @return (see MatrixInterface#t)
    #
    def StdlibInterface.t(m)
      m.t
    end
    
    #
    # Componentwise addition of two matrices.
    #
    # @param (see MatrixInterface#add)
    # @return (see MatrixInterface#add)
    #
    def StdlibInterface.add(m, n)
      m + n
    end
    
    #
    # Componentwise subtraction of two matrices.
    #
    # @param (see MatrixAdapter#sub)
    # @return (see MatrixAdapter#sub)
    #
    def StdlibInterface.sub(m, n)
      m - n
    end
    
    #
    # Compute the eigen-decomposition of a real symmetric matrix.
    #
    # The Ruby version uses Jacobi iterations to calculate the 
    # eigen-decomposition of a matrix. Although comfortable as all
    # third-party dependencies can be installed via gem, the method is
    # not suited for matrices bigger than 10x10.
    #
    # @param (see MatrixInterface#ed)
    # @return (see MatrixInterface#ed)
    #
    def StdlibInterface.ed(m)
      eigen_values = m.cJacobiA
      eigen_vectors = m.cJacobiV

      ranks = (0..(m.row_size-1)).sort{|i,j| eigen_values[j,j] <=> eigen_values[i,i]}
      
      s_eigen_values = []
      s_eigen_vectors = []
      ranks.each do |r|
        s_eigen_values << eigen_values[r,r]
        s_eigen_vectors << eigen_vectors.column(r)
      end    
      [Matrix.diagonal(*s_eigen_values), Matrix.columns(s_eigen_vectors)]
    end
    
  end
end
