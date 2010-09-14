#
# rmds - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'
require 'mds/interfaces/stdlib_interface'

class TestStdlibInterface < Test::Unit::TestCase
  include AutoTestMatrixInterface
  
  def setup
    @ma = MDS::StdlibInterface
  end
  
end
