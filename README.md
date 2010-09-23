# Ruby Multidimensional Scaling Library

## Introduction

RMDS is a library for performing multidimensional scaling. 

[Wikipedia][wiki_mds] describes multidimensional scaling (MDS) as
> [...] a set of related statistical techniques often used in information 
> visualization for exploring similarities or dissimilarities in data.

In essence, multidimensional scaling takes a matrix of similarities or dissimilarities between pairwise observations as input and outputs a matrix of observations in Cartesian coordinates that preserve the similarities/dissimilarities given. The dimensionality of the output is a parameter to the algorithm.

## Metric Multidimensional Scaling

RMDS implements metric multidimensional scaling in which dissimilarities are assumed to be distances. The result of this multidimensional scaling variant are coordinates in the Euclidean space that explain the given distances. In general, the embedding found is not unique. Any rotation or translation applied to found embedding does not change the pairwise distances.

## Linear Algebra Backends

RMDS makes heavy use of linear algebra routines, but does not ship with linear algebra algorithms. Instead, RMDS has a non-intrusive adapter architecture to connect existing linear algebra packages to RMDS. For how-to details on providing new adapters for RMDS see {MDS::MatrixInterface}.

Note that the performance of most RMDS algorithms is dominated by the algorithms and performance of the linear algebra backend used. 

Currently the following linear algebra backends are supported

- {MDS::StdlibInterface} - Connects Ruby's core matrix class to RMDS.
- {MDS::GSLInterface} - Connects the GNU Scientific Library to RMDS.
- {MDS::LinalgInterface} - Connects LAPACK and BLAS via Linalg to RMDS.

## Installation

RMDS is available as gem and as git repository. To install RMDS using Ruby gems invoke

    > gem install rmds
    
or clone the git repository

    > git clone git://github.com/cheind/rmds.git
   
If you like to contribute, drop note at christoph.heindl@gmail.com

## Examples

The following successfully calculates a two dimensional Cartesian embedding for a given distance matrix.
  
    require 'mds'
    require 'mds/interfaces/gsl_interface'
    
    # Tell RMDS the linear algebra backend to be used.
    MDS::Backend.interface = MDS::GSLInterface
    
    # The squared Euclidean distance matrix.
    d2 = MDS::Matrix.create_rows(
      [0.0, 10.0, 2.0], 
      [10.0, 0.0, 20.0], 
      [2.0, 20.0, 0.0]
    )
    
    # Find a Cartesian embedding in two dimensions
    # that approximates the distances in two dimensions.
    x = MDS::Metric.projectd(d2, 2)
    
The result, *x*, of the above example is shown in the following image. In red the coordinates that yield the input matrix *d2*. In green, the resulting embedding *x* which preserves distances between individual observations and is unique up to rigid transformations.

![Result of MDS](http://github.com/cheind/rmds/raw/master/docs/readme_example.png)

The following example works on a distance matrix which originates from air distances between european cities. It does not require a concrete linear algebra backend, but rather chooses an available one. The results are diagrammed graphically using Gnuplot and compared to the result from a mapping tool.

    require 'mds'
    require 'gnuplot' # gem install gnuplot
    
    # Load backend
    MDS::Backend.try_require
    MDS::Backend.active = MDS::Backend.first
    puts "Using backend #{MDS::Backend.active}"
    
    # Load distance matrix from file, contains city names in first column
    path = File.join(File.dirname(__FILE__), 'european_city_distances.csv')
    cities = []
    rows = MDS::IO::read_csv(path, ';') do |entry|
      begin
        f = Float(entry)
        f * f # we use squared distances
      rescue ArgumentError
        cities << entry
        nil
      end
    end
    
    # Invoke MDS

    d2 = MDS::Matrix.create_rows(*rows)      
    # Find a projection that preserves 90 percent of the variance of the distances.
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

The following image show the result of the above script. A map is shown in a separate image for comparison. 

Keep in mind that 
 
 - MDS finds an embedding up to rotation and translation
 - The input matrix contains air-distances and the map shows correct goedesic distances.

![Result of MDS](http://github.com/cheind/rmds/raw/master/docs/readme_mds_cities.png) 

![Result of Mapping](http://github.com/cheind/rmds/raw/master/docs/readme_cities.png)
    
## Benchmarks
The following tables show the results of benchmarking different linear algebra packages against three test scenarios. They were generated by invoking 'rake test:bench:all' on a QuadCore 2.4 GHz machine, running Ubuntu 10.4 inside a virtual machine.

Note that the each test involves creation of the observations randomly, calculating the squared euclidean distance matrix of observations and invoking MDS. The first two steps are not listed explicitely since they only take roughly 5 percent of the total runtime.

    Benchmarking RMDS for 10 observations in 2-dimensional space
                    user     system      total        real
    stdlib:     3.710000   1.220000   4.930000 (  5.195076)
    gsl:        0.000000   0.000000   0.000000 (  0.067544)
    linalg:     0.000000   0.000000   0.000000 (  0.005462)
    
    Benchmarking RMDS for 100 observations in 5-dimensional space
                    user     system      total        real
    stdlib:          inf        inf        inf (       inf)
    gsl:        0.030000   0.010000   0.040000 (  0.043115)
    linalg:     0.020000   0.010000   0.030000 (  0.043157)
    
    Benchmarking RMDS for 1000 observations in 10-dimensional space
                    user     system      total        real
    stdlib:          inf        inf        inf (       inf)
    gsl:       34.070000   1.390000  35.460000 ( 39.013276)
    linalg:    12.750000   0.340000  13.090000 ( 13.645427)
    
Because of documented limitations of {MDS::StdlibInterface} timings for this interface are shown only for the smallest of the three scenarios. Neither GSL nor LAPACK/BLAS was re-compiled for optimal performance.

## Documentation

An up-to-date documentation of the current master branch can be found [here](http://rdoc.info/github/cheind/rmds/master/frames).

## Requirements

RMDS itself does not have any dependencies except Ruby. Each matrix interface is likley to depend on one or more external projects, such as bindings and native libraries.

RMDS is tested against Ruby 1.8.7 and Ruby 1.9.1.

## License

*RMDS* is copyright 2010 Christoph Heindl. It is free software, and may be redistributed under the terms specified in the {file:LICENSE.md} file.

[wiki_mds]: http://en.wikipedia.org/wiki/Multidimensional_scaling "Wikipedia - Multidimensional Scaling"
