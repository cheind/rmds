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
    # Transform the squared distance matrix +D+ into a matrix of Cartesian 
    # coordinates by projecting +D+ onto the basis formed by eigen-decomposition
    # of the initial matrix. 
    #
    # The result is a matrix +F+ of dimensionality NxM, where N is the size of
    # +D+ and M equals +dims+.
    #
    # @param [MatrixAdapter] ma matrix adapter to use
    # @param d squared distance matrix +D+
    # @param [Float] k percent [0..1] of variances in distances to keep in embedding.
    # @return matrix containing the Cartesian embedding.
    #
    def Classic.project(ma, d, k)
      b = Classic.shift(ma, d)
      eval, evec = ma.ed(b)
      dims = Classic.find_dimensionality(ma, eval, k)
      
      diags = ma.diagonals(eval).map do |i| 
        i > 0.0 ? Math.sqrt(i) : i
      end
      lam = ma.create_diagonal(*diags) 
      lam = ma.minor(lam, 0..(ma.nrows(lam)-1), 0..(dims-1))
      ma.prod(evec,lam)
    end
    
    
    protected 
    
    def Classic.shift(ma, d)
      n = ma.nrows(d)
      # Nx1 matrix of ones
      ones = ma.create_scalar(n, 1, 1.0)
      # 1xN weight vector
      m = ma.create_scalar(1, n, 1.0/n)
      # NxN centering matrix
      xi = ma.sub(ma.create_identity(n), ma.prod(ones, m))
      # NxN shifted distances matrix, B
      # (xi * d * xi.t) * -0.5
      ma.prod(ma.prod(xi, ma.prod(d, ma.t(xi))), -0.5)
    end

    
    #
    # Find the dimensionality of the resulting coordinate space so that
    # at least +k+ percent of the variance of the distances is preserved.
    #
    def Classic.find_dimensionality(ma, eval, k)
      n = ma.nrows(eval)
      sum_ev = ma.trace(eval)
      
      i = 0
      sum = 0
      while ((i < n) && 
             (ma.get(eval,i,i) > 0.0) && 
             (sum / sum_ev) < k)
        sum += ma.get(eval,i,i)
        i += 1
      end
      i
    end
  end
  
end
