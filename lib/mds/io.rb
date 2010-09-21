#
# RMDS - Ruby Multidimensional Scaling Library
# Copyright (c) Christoph Heindl, 2010
# http://github.com/cheind/rmds
#

module MDS
  module IO

    #
    # Read matrix from CSV file
    # Each feature corresponds to a single row.
    # All rows are assumed to have an equal column count.
    #
    def IO.read_csv(path, sep = ' ')
      rows = []
      File.foreach(path) do |line|
        cells = line.chop.split(sep)
        if block_given?
          rows << cells.map{|c| yield c}.compact
        else
          rows << cells
        end
      end
      rows
    end
    
  end
end
