#
# mdsl - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://code.google.com/p/mdsl/
#

require 'test/unit'
require 'mds'

class TestClassic < Test::Unit::TestCase
  
  def test_2d
    x = Matrix.rows([
      [1.0, 2.0], 
      [4.0, 3.0],
      [0.0, 1.0]
    ])
    
    d = Matrix.l2_distances_squared(x)
    
    proj = MDS::Classic.project(d, 0.99)
    d_proj = Matrix.l2_distances_squared(proj)
    
    assert(Matrix.equal_in_delta?(d, d_proj))
  end
  
  def test_5d
    x = Matrix.random(15, 5, -10, 10)
    d = Matrix.l2_distances_squared(x)
    proj = MDS::Classic.project(d, 0.99)
    d_proj = Matrix.l2_distances_squared(proj)
    assert(Matrix.equal_in_delta?(d, d_proj, 1e-5))
  end
  
end
