#
# mdsl - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://code.google.com/p/mdsl/
#

require 'mds'

# Observations, usually unknown
x = Matrix.rows([
  [1.0, 2.0], # Point A
  [4.0, 3.0], # Point B
  [0.0, 1.0]  # Point C
])

# Calculate the squared Euclidean distance matrix of X,
# which is usually the only given input for MDS.

d = Matrix.l2_distances_squared(x)
   
# Find an Cartesian embedding of D, such that 99 percent
# of the variances of distances in D are preserved. 

x_proj = MDS::Classic.project(d, 0.99) 
  # => [[-0.60   0.28],
  #     [ 2.53  -0.08],
  #     [-1.93  -0.19]]

# Since distances are preserved it must hold
# that the squared Euclidean distance matrix of 
# x_proj equals D upto a certain delta.

diff = Matrix.l2_distances_squared(x_proj) - d
  # => [[0.0 0.0 0.0],
  #     [0.0 0.0 0.0],
  #     [0.0 0.0 0.0]]
  
# If less accuracy of preserved distances is needed,
# one may lower the percentage. In our case, 80% are
# reflected in an embedding with just one dimension.
#
# If you look at the original input, X, this is true,
# since all points are close be colinear.

x_proj = MDS::Classic.project(d, 0.8) 
  # => [[-0.60],
  #     [ 2.53],
  #     [-1.93]]

# Therefore, the distance matrix yields a reduced
# degree of accuracy.

diff = Matrix.l2_distances_squared(x_proj) - d
  # => [[ 0.0  -0.13 -0.23],
  #     [-0.13  0.0  -0.01],
  #     [-0.23 -0.01  0.0]]