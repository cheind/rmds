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
  # @param [MatrixAdapter] ma matrix adapter
  # @param [Matrix] x matrix of observations in rows.
  # @return [Matrix] squared Euclidean distance matrix of observations
  #
  def MDS.l2_distances_squared(ma, x)
    # Product of x with transpose of x
    xxt = ma.prod(x, ma.t(x))
    # 1xN matrix of ones, where N size of xxt
    ones = ma.create_scalar(1, ma.nrows(xxt), 1.0)
    # Nx1 matrix containing diagonal elements of x
    diagonals = ma.diagonals(xxt)
    c = ma.create_block(ma.nrows(xxt), 1) do |i, j|
      diagonals[i]
    end
    # Distance matrix NxN as c * ones + (c * ones).t - xxt*2
    c_ones = ma.prod(c, ones)
    c_ones_t = ma.t(c_ones)
    ma.sub(ma.add(c_ones, c_ones_t), ma.prod(xxt, 2.0))
  end
end

