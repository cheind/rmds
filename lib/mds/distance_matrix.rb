#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://code.google.com/p/mdsl/
#

require 'mds/matrix'

class Matrix
  
  #
  # Calculates the squared Euclidean distance matrix, +D+,
  # containing the pairwise squared Euclidean distances of
  # given observations.
  #
  # @param [Matrix] x matrix of observations in rows.
  # @return [Matrix] squared Euclidean distance matrix of observations
  #
  def Matrix.l2_distances_squared(x)
    # Product of x with transpose of x
    xxt = x * x.t
    # 1xN matrix of ones, where N size of xxt
    ones = Matrix.rows([[1.0]*xxt.row_size])
    # Nx1 matrix containing diagonal elements of x
    c = Matrix.columns([xxt.diagonal])
    # Distance matrix NxN
    c * ones + (c * ones).t - xxt*2
  end
end

