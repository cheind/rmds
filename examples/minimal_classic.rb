#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

# Load RMDS
require 'mds'

# Prepare the linear algebra backend to be used.
require 'mds/interfaces/gsl_interface'
MDS::Matrix.interface = MDS::GSLInterface

# The squared Euclidean distance matrix.
d2 = MDS::Matrix.create_rows(
  [0.0, 10.0, 2.0], 
  [10.0, 0.0, 20.0], 
  [2.0, 20.0, 0.0]
)

# Find a Cartesian embedding in two dimensions
# that approximates the distances in d2.
x = MDS::Classic.projectd(d2, 2) 

puts x.matrix
# x => -0.6037  0.2828
#       2.5370 -0.0841
#      -1.9330 -0.1987



