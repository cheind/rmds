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
    # Visualization of air distances between major european cities.
    #
    # Compare result with http://bit.ly/bNdf0e but keep in mind that
    #
    # - MDS finds an embedding up to rotation and translation
    # - The input matrix contains air-distances and the map shows correct goedesic distances.
    #
    def Examples.visualization_european_cities
      require 'mds'
      require 'gnuplot' # gem install gnuplot
      
      # Load backend
      MDS::Backend.try_require
      MDS::Backend.active = MDS::Backend.first
      puts "Using backend #{MDS::Backend.active}"
      
      # Load matrix from file, contains city names in first column
      path = File.join(File.dirname(__FILE__), 'european_city_distances.csv')
      
      cities = []
      rows = MDS::IO::read_csv(path, ';') do |entry|
        begin
          f = Float(entry)
          f * f
        rescue ArgumentError
          cities << entry
          nil
        end
      end
      
      # Invoke MDS

      d2 = MDS::Matrix.create_rows(*rows)      
      proj = MDS::Metric.projectk(d2, 0.9) 
      
      # Plot results
      
      Gnuplot.open do |gp|
        Gnuplot::Plot.new( gp ) do |plot|
          
          # Uncomment the following lines to write result to image.
          # plot.term 'png size'
          # plot.output 'visualization.png'
          
          plot.title "Air Distances between European Cities"  
          plot.xrange "[-2000:2000]"
          plot.yrange "[-1500:1200]"
          
          plot.data << Gnuplot::DataSet.new(proj.columns) do |ds|
            ds.with = "points"
            ds.notitle
          end
          
          cities.each_with_index do |name, i|
            plot.label "'#{name}' at #{proj[i,0] + 30}, #{proj[i,1] + 30}"
          end
        end
      end
   
    end
  end
  
end

if __FILE__ == $0
  require 'rubygems'
  $:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  MDS::Examples.visualization_european_cities
end


