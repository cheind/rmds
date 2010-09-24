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
    # Illustrates usage of {MDS::Metric} for dimensionality reduction.
    #
    def Examples.dimensionality_reduction
      require 'mds'
      
      MDS::Backend.load_backends
      MDS::Backend.active = MDS::Backend.first
      puts "Using backend #{MDS::Backend.active}"
      
      # Consider the following observations from a line in 
      # three-dimensional space

      x = MDS::Matrix.create_rows(
        [1.0, 2.0, 0.0], # Point A
        [3.0, 4.0, 0.0], # Point B
        [6.0, 7.0, 0.0]  # Point C
      )
      
      # the distances between observations can be preserved
      # even if we project the observations onto a one-dimensional
      # space where the frames axis corresponds to the line itself.
      
      d = MDS::Metric.squared_distances(x)
      
      # In our example it is obvious from the datapoints that a one dimensional
      # embedding must exist and we could enforce this using {MDS::Metric.projectd). 
      # In general case, however, we only tell RMDS how many percent of the variances 
      # of distances our embedding should preserve. 
     
      x_reduced = MDS::Metric.projectk(d, 0.99) 
      
      # The result is a one dimensional embedding that preserves the given inter-point distances
      # of x
      
      puts "Resulting dimensionality is #{x_reduced.ncols}"
   end
  end
end
  
  
if __FILE__ == $0
  $:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  MDS::Examples.dimensionality_reduction
end
