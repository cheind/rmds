#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require 'mds/test/matrix_assertions.rb'

module MDS
  module Test
  
    #
    # Module containing standarized tests for MDS::Metric.
    #
    module BundleMetric
      include MDS::Test::MatrixAssertions
      
      def test_squared_distances
        input = MDS::Matrix.create_rows(
          [1.0, 2.0], 
          [4.0, 3.0],
          [0.0, 1.0]
        )
        
        output = MDS::Matrix.create_rows(
          [0.0, 10.0, 2.0], 
          [10.0, 0.0, 20.0], 
          [2.0, 20.0, 0.0]
        )
        
        d = MDS::Metric.squared_distances(input)
        assert_equal_matrices(output, d)
      end
      
      def test_k_2d
        x = MDS::Matrix.create_rows(
          [1.0, 2.0], 
          [4.0, 3.0],
          [0.0, 1.0]
        )
        d = MDS::Metric::squared_distances(x)
        proj = MDS::Metric.projectk(d, 0.99)   
        dd = MDS::Metric.squared_distances(proj)    
        assert_delta_matrices(d, dd, 1e-5)
      end
      
      def test_d_2d
        x = MDS::Matrix.create_rows(
          [1.0, 2.0], 
          [4.0, 3.0],
          [0.0, 1.0]
        )
        d = MDS::Metric.squared_distances(x)
        
        proj = MDS::Metric.projectd(d, 2)   
        dd = MDS::Metric.squared_distances(proj)    
        assert_delta_matrices(d, dd, 1e-5)
      end
      
      def test_k_5d
        x = MDS::Matrix.create_random(10, 5, -10, 10)   
        d = MDS::Metric.squared_distances(x)
        
        proj = MDS::Metric.projectk(d, 1.0)   
        dd = MDS::Metric.squared_distances(proj)    
        assert_delta_matrices(d, dd, 1e-5)
        
        proj = MDS::Metric.projectk(d, 0.8)   
        dd = MDS::Metric.squared_distances(proj)    
        assert_delta_matrices(d, dd, 5e2)
      end
      
      def test_d_5d
        x = MDS::Matrix.create_random(10, 5, -10, 10)   
        d = MDS::Metric.squared_distances(x)
        proj = MDS::Metric.projectd(d, 10)   
        dd = MDS::Metric.squared_distances(proj)    
        assert_delta_matrices(d, dd, 1e-5)
      end
    end
  end
end
