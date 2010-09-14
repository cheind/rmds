#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

module MDS
  
  #
  # Calculates the squared Euclidean distance matrix, +D+,
  # containing the pairwise squared Euclidean distances of
  # given observations.
  #
  # @param [MatrixAdapter] x matrix of observations in rows.
  # @return [MatrixAdapter] squared Euclidean distance matrix of observations
  #
  def MDS.l2_distances_squared(x)
    # Product of x with transpose of x
    xxt = x * x.t
    # 1xN matrix of ones, where N size of xxt
    ones = MatrixAdapter.new(x.interface.create(1, xxt.nrows, 1.0), x.interface)
    # Nx1 matrix containing diagonal elements of x
    diagonals = xxt.diagonals
    c = MatrixAdapter.new(x.interface.create_block(xxt.nrows, 1) do |i, j|
      diagonals[i]
    end, x.interface)
    c * ones + (c * ones).t - xxt * 2
  end
end

