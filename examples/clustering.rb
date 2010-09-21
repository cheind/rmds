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
    # K-Means clustering
    #
    class KMeans 
      # The matrix representing cluster centers
      attr_reader :centers
      
      def initialize(k, box)
        @centers = MDS::Matrix.create_block(k, box.lower.length) do |i,j|
          box.lower[j] + rand() * (box.upper[j] - box.lower[j])
        end
      end
      
      def train(x, eta = 0.1)

      end
      
      def classify(x)
        # Find closest center to each observation
        closest_ids = 0..(x.nrows-1).map do |i|
          best_dist2 = Float.MAX
          best_id = -1
          
          
          
        end
      end
      
      private
      
      def closest_center_id(x, i)
        best = 
      end
      
      
    end

    #
    # Datamining the results of {MDS::Metric}
    #
    def Examples.clustering
      require 'mds'
      require 'mds/interfaces/stdlib_interface'
      require 'gnuplot'
      
      MDS::Backend.active = MDS::StdlibInterface

      # Input
      x = MDS::Matrix.create_rows(
        [1.0, 2.0], # Point A
        [4.0, 3.0], # Point B
        [0.0, 1.0]  # Point C
      )
      
      d2 = MDS::Metric.squared_distances(x)
      
      # Embedding in R2
      proj = MDS::Metric.projectd(d2, 2) 
      
      Gnuplot.open do |gp|
        Gnuplot::Plot.new( gp ) do |plot|
          
          # Uncomment the following lines to write result to image.
          # plot.term 'png size'
          # plot.output 'visualization.png'
          
          plot.title "Original Input and Result of MDS in Two Dimensions"  
          plot.xrange "[-5:5]"
          plot.yrange "[-5:5]"
          
          plot.data << Gnuplot::DataSet.new(x.columns) do |ds|
            ds.with = "points"
            ds.title = "Input"
          end
          
          plot.data << Gnuplot::DataSet.new(proj.columns) do |ds|
            ds.with = "points"
            ds.title = "Output"
          end
   
        end
      end
      
    
    end
  end
  
end

if __FILE__ == $0
  require 'rubygems'
  $:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  MDS::Examples.clustering
end


