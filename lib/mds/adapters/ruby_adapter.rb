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
  # Adaptor for standard ruby matrices.
  # 
  #
  class RubyAdapter < MatrixAdapter
    
    def create_scalar(n, m, s)
      raise NotImplementedError
    end
    
    def set(m, i, j, s)
      raise NotImplementedError
    end
    
    def get(m, i, j)
      raise NotImplementedError
    end
    
    def prod(m, n)
      raise NotImplementedError
    end
    
    def add(m, n)
      raise NotImplementedError
    end
    
    def sub(m, n)
      raise NotImplementedError
    end
    
  end
end