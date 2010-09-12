#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://code.google.com/p/mdsl/
#

require 'mds/matrix'

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
    def Classic.project(d, k)
      b = Classic.shift(d)
      eval, evec = b.eigen_decomposition
      dims = Classic.find_dimensionality(eval, k)
      
      lambda = Matrix.diagonal(*eval.diagonals.map {|i| Math.sqrt(i) if i > 0.0})
      lambda = lambda.minor(0..(lambda.row_size-1), 0..(dims-1))

      evec * lambda
    end
    
    
    protected 
    
    def Classic.shift(d)
      n = d.row_size
      # Nx1 matrix of ones
      ones = Matrix.columns([[1.0]*n])
      # 1xN weight vector
      m = Matrix.rows([[1.0/n]*n])
      # NxN centering matrix
      xi = Matrix.identity(n) - ones * m
      # NxN shifted distances matrix, B
      (xi * d * xi.t) * -0.5
    end

    
    #
    # Find the dimensionality of the resulting coordinate space so that
    # at least +k+ percent of the variance of the distances is preserved.
    #
    def Classic.find_dimensionality(eval, k)
      n = eval.row_size
      sum_ev = eval.trace
      
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
