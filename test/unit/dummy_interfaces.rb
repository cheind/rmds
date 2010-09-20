#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require 'mds/matrix_interface'

module X
  class DummyInterface0 < MDS::MatrixInterface
  end
  
  module Y
    class DummyInterface1 < MDS::MatrixInterface
    end
  end
  
  class DummyInterface2 < Y::DummyInterface1
  end
end
