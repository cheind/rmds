#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

module MDS

  #
  # In classical MDS dissimilarities are interpreted as distances und 
  # the goal is to find an embedding in an Euclidean space that best preserves
  # the given distances.
  #
  class Classic
    
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
    def Classic.projectk(d, k)
      b = Classic.shift(d)
      eval, evec = b.ed
      dims = Classic.find_dimensionality(eval, k)
      Classic.project(eval, evec, dims)      
    end
    
    #
    # Find a Cartesian embedding for the given distances.
    #
    # @param [MDS::Matrix] d squared Eulcidean distance matrix of observations
    # @param [Integer] dims the number of dimensions of the embedding.
    # @return [MDS::Matrix] the matrix containing the cartesian embedding.
    #
    def Classic.projectd(d, dims)
      b = Classic.shift(d)
      eval, evec = b.ed
      Classic.project(eval, evec, dims)
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
    def Classic.project(eval, evec, dims)     
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
    def Classic.shift(d)
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
    def Classic.find_dimensionality(eval, k)
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
