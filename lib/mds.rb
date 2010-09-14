#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

#
# MDS - Ruby Multidimensional Scaling
#
module MDS
  # Current version of MDS
  VERSION = '0.2'
end

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'mds/matrix_interface'
require 'mds/matrix'
require 'mds/euclidean_space'
require 'mds/classic'


