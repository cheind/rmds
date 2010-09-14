#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'
begin
  require 'mds/interfaces/stdlib_interface'
rescue LoadError
end

class TestDistanceMatrix < Test::Unit::TestCase
  include MatrixAssertions

  def test_l2_distance_matrix
    input = Matrix[
      [1.0, 2.0], 
      [4.0, 3.0],
      [0.0, 1.0]
    ]
    
    output = Matrix[
      [0.0, 10.0, 2.0], 
      [10.0, 0.0, 20.0], 
      [2.0, 20.0, 0.0]
    ]
    
    x = MDS::MatrixAdapter.new(input, MDS::StdlibInterface)
    d = MDS.l2_distances_squared(x)

    assert_equal_matrices(       
      MDS::MatrixAdapter.new(output, MDS::StdlibInterface),
      d
    )
  end
end
