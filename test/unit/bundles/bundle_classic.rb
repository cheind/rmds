#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'

#
# Module containing standarized tests for MDS::Classic.
#
module BundleClassic
  include MatrixAssertions
  
  def test_k_2d
    x = MDS::Matrix.create_rows(
      [1.0, 2.0], 
      [4.0, 3.0],
      [0.0, 1.0]
    )
    d = MDS::EuclideanSpace::squared_distances(x)
    proj = MDS::Classic.projectk(d, 0.99)   
    dd = MDS::EuclideanSpace::squared_distances(proj)    
    assert_delta_matrices(d, dd, 1e-5)
  end
  
  def test_d_2d
    x = MDS::Matrix.create_rows(
      [1.0, 2.0], 
      [4.0, 3.0],
      [0.0, 1.0]
    )
    d = MDS::EuclideanSpace::squared_distances(x)
    
    proj = MDS::Classic.projectd(d, 2)   
    dd = MDS::EuclideanSpace::squared_distances(proj)    
    assert_delta_matrices(d, dd, 1e-5)
  end
  
  def test_k_5d
    x = MDS::Matrix.create_random(10, 5, -10, 10)   
    d = MDS::EuclideanSpace::squared_distances(x)
    
    proj = MDS::Classic.projectk(d, 1.0)   
    dd = MDS::EuclideanSpace::squared_distances(proj)    
    assert_delta_matrices(d, dd, 1e-5)
    
    proj = MDS::Classic.projectk(d, 0.8)   
    dd = MDS::EuclideanSpace::squared_distances(proj)    
    assert_delta_matrices(d, dd, 5e2)
  end
  
  def test_d_5d
    x = MDS::Matrix.create_random(10, 5, -10, 10)   
    d = MDS::EuclideanSpace::squared_distances(x)
    proj = MDS::Classic.projectd(d, 10)   
    dd = MDS::EuclideanSpace::squared_distances(proj)    
    assert_delta_matrices(d, dd, 1e-5)
  end
end

