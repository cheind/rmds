#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

module MDS

  #
  # Examples for RMDS
  #
  module Examples
    #
    # Illustrates usage of {MDS::Metric}
    #
    def Examples.extended_metric
      require 'mds'
      
      # Prepare the linear algebra backend to be used.
      require 'mds/interfaces/stdlib_interface'
      MDS::Matrix.interface = MDS::StdlibInterface
    
      # Observations, usually unknown
      x = MDS::Matrix.create_rows(
        [1.0, 2.0], # Point A
        [4.0, 3.0], # Point B
        [0.0, 1.0]  # Point C
      )

      # Calculate the squared Euclidean distance matrix of observations,
      # which is usually the only given input for MDS.

      d = MDS::Metric.squared_distances(x)
         
      # Find an Cartesian embedding of D, such that 99 percent
      # of the variances of distances in D are preserved. 

      x_proj = MDS::Metric.projectk(d, 0.99) 
        # => [[-0.60   0.28],
        #     [ 2.53  -0.08],
        #     [-1.93  -0.19]]

      # Since distances are preserved it should hold
      # that the squared Euclidean distance matrix of 
      # x_proj equals D upto a certain delta.

      diff = MDS::Metric.squared_distances(x_proj) - d
        # => [[0.0 0.0 0.0],
        #     [0.0 0.0 0.0],
        #     [0.0 0.0 0.0]]
        
      puts "Deviation from input"
      puts diff.matrix
        
      # If less accuracy of preserved distances is needed,
      # one may lower the percentage. In our case, 80% are
      # reflected in an embedding with just one dimension.
      #
      # If you look at the original input, X, this is true,
      # since all points are close be colinear.

      x_proj = MDS::Metric.projectk(d, 0.8) 
        # => [[-0.60],
        #     [ 2.53],
        #     [-1.93]]

      # Therefore, the distance matrix yields a reduced
      # degree of accuracy.

      diff = MDS::Metric.squared_distances(x_proj) - d
        # => [[ 0.0  -0.13 -0.23],
        #     [-0.13  0.0  -0.01],
        #     [-0.23 -0.01  0.0]]
    end
  end
end
  
  
if __FILE__ == $0
  $:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  MDS::Examples.extended_metric
end
