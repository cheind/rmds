#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#


#
# Examples for RMDS
#
module Examples

  #
  # Illustrates usage of {MDS::Metric}.
  #
  # Given a matrix of squared Euclidean distances, find
  # a two-dimensional Cartesian embedding.
  #
  def Examples.minimal_metric
    # Load RMDS
    require 'mds'

    # Prepare the linear algebra backend to be used.
    require 'mds/interfaces/gsl_interface'
    MDS::Matrix.interface = MDS::GSLInterface

    # The squared Euclidean distance matrix.
    d2 = MDS::Matrix.create_rows(
      [0.0, 10.0, 2.0], 
      [10.0, 0.0, 20.0], 
      [2.0, 20.0, 0.0]
    )

    # Find a Cartesian embedding in two dimensions
    # that approximates the distances in d2.
    x = MDS::Metric.projectd(d2, 2) 

    puts x.matrix
    # x => -0.6037  0.2828
    #       2.5370 -0.0841
    #      -1.9330 -0.1987
  end
end

if __FILE__ == $0
  $:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  Examples.minimal_metric
end


