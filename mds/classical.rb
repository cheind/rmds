#
# mdsl - Ruby Multidimensional Scaling Library
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
  class Classical
    
    #
    # Initialize from the distance matrix +D+.
    # 
    def initialize(d)
      self.find_basis(d)
    end
    
    #
    # Find the dimensionality of the resulting coordinate space so that
    # at least +k+ percent of the variance of the distances is preserved.
    #
    def min_dims(k)
      ev = @eigen_values
      n = ev.row_size
      sum_ev = ev.trace
      
      i = 0
      sum = 0
      while ((i < n) && 
             (ev[i,i] > 0.0) && 
             (sum / sum_ev) < k)
        sum += ev[i,i]
        i += 1
      end
      i
    end
    
    #
    # Transform the squared distance matrix +D+ into a matrix of Cartesian 
    # coordinates by projecting +D+ onto the basis formed by eigen-decomposition
    # of the initial matrix. 
    #
    # The result is a matrix +F+ of dimensionality NxM, where N is the size of
    # +D+ and M equals +dims+.
    # 
    def project(d, dims)
      n = d.row_size
      mm = Matrix.diagonal(*[1.0/Math.sqrt(1.0/n)]*n)
      ll = Matrix.diagonal(*@eigen_values.diagonals.map {|i| Math.sqrt(i)})
      ll = ll.minor(0..(n-1), 0..(dims-1))
      @eigen_vectors * ll
    end
    
    protected
    
    #
    # The result corresponds to the eigen-decomposition of
    # the distance matrix, +D, transformed to an equivalent scalar
    # product matrix.
    #
    # The eigen-decomposition yields an orthonormal frame in R^N
    # that describes the principal components of the input matrix.
    #
    # The resulting eigen-vectors and values are sorted in
    # descending order of eigen-value importance.
    #
    #
    def find_basis(d)
      n = d.row_size
      # Nx1 matrix of ones
      ones = Matrix.columns([[1.0]*n])
      # 1xN weight vector
      m = Matrix.rows([[1.0/n]*n])
      # NxN centering matrix
      xi = Matrix.identity(n) - ones * m
      # NxN shifted distances matrix
      b = (xi * d * xi.t) * -0.5
      
      # Perform eigen decomposition and sort
      eigen_values = b.cJacobiA
      eigen_vectors = b.cJacobiV
      ranks = (0..(n-1)).sort{|i,j| eigen_values[j,j] <=> eigen_values[i,i]}
      
      s_eigen_values = []
      s_eigen_vectors = []
      ranks.each do |r|
        s_eigen_values << eigen_values[r,r]
        s_eigen_vectors << eigen_vectors.column(r)
      end
      
      @eigen_values = Matrix.diagonal(*s_eigen_values)
      @eigen_vectors = Matrix.columns(s_eigen_vectors)
    end
  end
  
end
