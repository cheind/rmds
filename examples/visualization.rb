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
    # Visualization of {MDS::Metric} output.
    #
    # Visually illustrates that MDS finds an embedding 
    # that is unique except for any rigid transformation 
    # applied to it.
    #
    def Examples.visualization
      require 'mds'
      require 'mds/interfaces/stdlib_interface'
      require 'gnuplot'
      
      MDS::Matrix.interface = MDS::StdlibInterface

      # Input
      x = MDS::Matrix.create_rows(
        [1.0, 2.0], # Point A
        [4.0, 3.0], # Point B
        [0.0, 1.0], # Point C
        [1.0, 1.0]  # Point D
      )
      
      d2 = MDS::Metric.squared_distances(x)
      
      # Embedding in R2
      proj = MDS::Metric.projectd(d2, 2) 
      
      Gnuplot.open do |gp|
        Gnuplot::Plot.new( gp ) do |plot|
          
          # Uncomment the following lines to write result to image.
          # plot.term 'png'
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
  MDS::Examples.visualization
end


