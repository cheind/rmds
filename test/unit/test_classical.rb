#
# mdsl - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://code.google.com/p/mdsl/
#

require 'test/unit'
require 'mds'

class TestClassical < Test::Unit::TestCase
  
  def test_2d
    x = Matrix.rows([
      [1.0, 2.0], 
      [4.0, 3.0],
      [0.0, 1.0]
    ])
    
    d = Matrix.l2_distances_squared(x)
    c = MDS::Classical.new(d)
    proj = c.project(d, c.min_dims(0.99))
    d_proj = Matrix.l2_distances_squared(proj)
    assert(Matrix.equal_in_delta?(d, d_proj))
  end
  
end
