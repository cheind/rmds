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
end
