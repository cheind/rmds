#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

module MDS
  
  #
  # Methods in euclidean space.
  #
  class EuclideanSpace
  
    #
    # Calculates the squared Euclidean distances for all
    # pairwise observations in the given matrix. Each observation 
    # corresponds to a matrix row and is provided in Cartesian coordinates.
    #
    # The result is a real symmetric matrix of size +NxN+, where +N+ is the
    # number of observations in the input. Each element +(i,j)+ in this matrix
    # corresponds to the squared distance between the i-th and j-th observation
    # in the input matrix.
    #
    # @param [MDS::Matrix] x the matrix of observations.
    # @return [MDS::Matrix] the squared Euclidean distance matrix
    #
    def EuclideanSpace.squared_distances(x)
      # Product of x with transpose of x
      xxt = x * x.t
      # 1xN matrix of ones, where N size of xxt
      ones = Matrix.create(1, xxt.nrows, 1.0)
      # Nx1 matrix containing diagonal elements of x
      diagonals = xxt.diagonals
      c = Matrix.create_block(xxt.nrows, 1) do |i, j|
        diagonals[i]
      end
      c * ones + (c * ones).t - xxt * 2
    end
  end
  

end

