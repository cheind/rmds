#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://code.google.com/p/mdsl/
#

begin
  require 'extendmatrix'
rescue LoadError
  warn "\n**Notice: RubyAdapter requires \'extendmatrix\' which was not found."
  warn "You can install the extension as follows: \n gem install extendmatrix \n"
  raise $!
end

module MDS
  
  #
  # Adapterr for standard ruby matrices.
  # 
  #
  class RubyAdapter < MatrixAdapter
    
    #
    # Create a new matrix with equal elements.
    #
    # @param (see MatrixAdapter#create_scalar)
    #
    def create_scalar(n, m, s)
      ::Matrix.build(n, m, s)
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
    #
    def get(m, i, j)
      m[i,j]
    end
    
    #
    # Calculate the product of two matrices or
    # the product of a matrix and a scalar.
    #
    # @param (see MatrixAdapter#prod)
    #
    def prod(m, n)
      m * n
    end
    
    #
    # Componentwise addition of two matrices.
    #
    # @param (see MatrixAdapter#add)
    #
    def add(m, n)
      m + n
    end
    
    #
    # Componentwise subtraction of two matrices.
    #
    # @param (see MatrixAdapter#sub)
    #
    def sub(m, n)
      m - n
    end
    
  end
end