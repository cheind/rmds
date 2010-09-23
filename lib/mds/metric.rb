#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

module MDS

  #
  # In metric MDS dissimilarities are interpreted as distances und 
  # the goal is to find an embedding in an Euclidean space that best preserves
  # the given distances.
  #
  # This implementation gives an analytical solution and avoids iterative
  # optimization. The performance of the algorithm highly depends on the 
  # implementation of the eigen-decomposition provided via {MDS::MatrixInterface}.
  #
  # *Examples*
  # - {Examples.minimal_metric}
  # - {Examples.extended_metric}
  #
  class Metric
    
    #
    # Find a Cartesian embedding for the given distances.
    #
    # Instead of a fixed dimensionality for the resulting embedding, this
    # method determines the dimensionality based on the variances of distances
    # in its input matrix and the parameter passed. The parameter specifies
    # the percent of variance of distance to preserve in the Cartesian embedding.
    #
    # @param [MDS::Matrix] d squared Eulcidean distance matrix of observations
    # @param [Float] k the percent of variance of distances 
    # to preserve in embedding in the range [0..1].
    # @return [MDS::Matrix] the matrix containing the cartesian embedding.
    #
    def Metric.projectk(d, k)
      b = Metric.shift(d)
      eval, evec = b.ed
      dims = Metric.find_dimensionality(eval, k)
      Metric.project(eval, evec, dims)      
    end
    
    #
    # Find a Cartesian embedding for the given distances.
    #
    # @param [MDS::Matrix] d squared Eulcidean distance matrix of observations
    # @param [Integer] dims the number of dimensions of the embedding.
    # @return [MDS::Matrix] the matrix containing the cartesian embedding.
    #
    def Metric.projectd(d, dims)
      b = Metric.shift(d)
      eval, evec = b.ed
      Metric.project(eval, evec, dims)
    end
    
    #
    # Calculates the squared Euclidean distances for all
    # pairwise observations in the given matrix. Each observation 
    # corresponds to a matrix row and is provided in Cartesian coordinates.
    #
    # The result is a real symmetric matrix of size +NxN+, where +N+ is the
    # number of observations in the input. Each element (i,j) in this matrix
    # corresponds to the squared distance between the i-th and j-th observation
    # in the input matrix.
    #
    # @param [MDS::Matrix] x the matrix of observations.
    # @return [MDS::Matrix] the squared Euclidean distance matrix
    #
    def Metric.squared_distances(x)
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
    
    
    protected 
    
    #
    # Transform the squared distance matrix into a matrix of Cartesian 
    # coordinates by projecting the distances onto the basis formed by
    # the eigen-decomposition of the initial matrix. 
    #
    # @param [MDS::Matrix] d squared Euclidean distance matrix
    # @param [Float] k percent [0..1] of variances in distances to keep in embedding.
    # @return [MDS::Matrix] containing the Cartesian embedding.
    #
    def Metric.project(eval, evec, dims)     
      lam = eval.minor(0..eval.nrows-1, 0..dims-1)
      for i in 0..lam.ncols-1
        v = lam[i,i]
        if v > 0.0
          lam[i,i] = Math.sqrt(v)
        end
      end
      evec * lam
    end
    
    #
    # Transforms the distance matrix into an equivalent scalar product
    # matrix.
    # 
    # @param [MDS::Matrix] d the squared Euclidean distance matrix
    # @return [MDS::Matrix] the equivalent scalar product matrix.
    #
    def Metric.shift(d)
      # Nx1 matrix of ones
      ones = Matrix.create(d.nrows, 1, 1.0)
      # 1xN weight vector
      m = Matrix.create(1, d.nrows, 1.0/d.nrows)
      # NxN centering matrix
      xi = Matrix.create_identity(d.nrows) - ones * m
      # NxN shifted distances matrix, B
      (xi * d * xi.t) * -0.5
    end

    
    #
    # Find the dimensionality of the resulting coordinate space so that
    # at least +k+ percent of the variance of the distances is preserved.
    #
    # @param [MDS::Matrix] eval the diagonal matrix of sorted eigen-values.
    # @param [Float] k percent of variance to keep.
    # @return [Integer] minimum number of dimensions to use, to keep k-percent
    # of variances of distances in embedding.
    #
    def Metric.find_dimensionality(eval, k)
      sum_ev = eval.trace
      n = eval.nrows
      
      i = 0
      sum = 0
      while ((i < n) && 
             (eval[i,i] > 0.0) && 
             (sum / sum_ev) < k)
        sum += eval[i,i]
        i += 1
      end
      i
    end
  end
  
end
