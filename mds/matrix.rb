#
# mdsl - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://code.google.com/p/mdsl/
#

begin
  require 'extendmatrix'
rescue LoadError
  require 'rubygems'
  gem 'extendmatrix'
  require 'extendmatrix'
end

class Matrix
  #
  # Returns diagonal matrix elements as Array
  #
  def diagonals
    (0..self.row_size-1).map {|i| self[i,i]}
  end
  
  #
  # Return the eigen-decomposition of this matrix as an array
  # of two-matrices: a diagonal matrix of eigenvalues, and the matrix
  # of eigen vectors, stored in columns.
  #
  # Eigen-values and vectors are sorted descending in the order of 
  # importance.
  #
  def eigen_decomposition
    n = self.row_size
    eigen_values = self.cJacobiA
    eigen_vectors = self.cJacobiV
    ranks = (0..(n-1)).sort{|i,j| eigen_values[j,j] <=> eigen_values[i,i]}
      
    s_eigen_values = []
    s_eigen_vectors = []
    ranks.each do |r|
      s_eigen_values << eigen_values[r,r]
      s_eigen_vectors << eigen_vectors.column(r)
    end
    
    [Matrix.diagonal(*s_eigen_values), Matrix.columns(s_eigen_vectors)]
  end
end
