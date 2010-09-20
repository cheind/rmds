#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

module MDS
  #
  # Examples for RMDS
  #
  module Examples

    #
    # Illustrates advanced usage of {MDS::Backend}.
    #
    def Examples.adaptive_backend(argv)
      require 'mds'
      
      # Try adding interfaces from command line arguments
      # Make sure that at least the standard RMDS interfaces
      # are included
      argv << './lib/mds/interfaces/*.rb'
      
      while !argv.empty?
        MDS::Backend.try_require(argv.shift)
      end
      
      # Select the first available interface.
      # Additionally pass an array of interace names that are preferred.
      interface = MDS::Backend.first(['MDS::GSLInterface', 'MDS::LinalgInterface'])
      raise 'No interface found' unless interface
      puts "Using interface #{interface}"
      
      MDS::Backend.active = interface

      # The squared Euclidean distance matrix.
      d2 = MDS::Matrix.create_rows(
        [0.0, 10.0, 2.0], 
        [10.0, 0.0, 20.0], 
        [2.0, 20.0, 0.0]
      )

      # Find a Cartesian embedding in two dimensions
      # that approximates the distances in d2.
      x = MDS::Metric.projectd(d2, 2) 

      puts x.matrix
      # x => -0.6037  0.2828
      #       2.5370 -0.0841
      #      -1.9330 -0.1987
    end
  end
  
end

if __FILE__ == $0
  $:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  MDS::Examples.adaptive_backend(ARGV)
end


