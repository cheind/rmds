#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

require './test/test_helper.rb'

class TestBackend < Test::Unit::TestCase

  class << self
    def startup
      @before = MDS::Backend.available.clone
      MDS::Backend.available.clear
      MDS::Backend.try_require('./test/unit/dummy_interfaces.*')
    end
    
    def shutdown
      MDS::Backend.available.clear
      MDS::Backend.available.concat(@before)
    end
    
    def suite
      mysuite = super
      def mysuite.run(*args)
        TestBackend.startup()
        super
        TestBackend.shutdown()
      end
      mysuite
    end
  end

  def test_available_interfaces
    assert_equal([X::DummyInterface0, X::Y::DummyInterface1, X::DummyInterface2], MDS::Backend.available)
  end  
  
  def test_first
    assert_equal(X::Y::DummyInterface1, MDS::Backend.first(['X::NotHere', 'X::Y::DummyInterface1', 'X::DummyInterface2']))
    assert_equal(X::DummyInterface0, MDS::Backend.first(['X::NotHere']))
    assert_equal(X::DummyInterface0, MDS::Backend.first )
  end

end
