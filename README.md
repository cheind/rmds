# Ruby Multidimensional Scaling Library

## Introduction

*RMDS* is a library for performing multidimensional scaling. 

[Wikipedia][wiki_mds] describes multidimensional scaling as
> [...] a set of related statistical techniques often used in information 
> visualization for exploring similarities or dissimilarities in data.

In essence, multidimensional scaling takes a matrix of similarities or dissimilarities between pairwise observations as input and outputs a matrix of observations in Cartesian coordinates that preserve the similarities/dissimilarities given. The dimensionality of the output is a parameter to the algorithm.

In general, the embedding found is not unique. Any rotation or translation applied to found embedding does not change the pairwise distances.

Multidimension scaling problems are commonly stated as optimization problems that attempt to minimize the error between distances provided and distances calculated from the current state of configuration. For some objective functions an analytical solution exists.

The following multidimensional scaling variants are offerred by *RMDS*

### Classical Scaling

In classical multidimensional scaling the dissimilarities are assumed to be distances. The result of this multidimensional scaling variant are coordinates that explain the distances.

Implemented in {MDS::Classic}. {file:examples/example_classic.rb}

[wiki_mds]: http://en.wikipedia.org/wiki/Multidimensional_scaling "Wikipedia - Multidimensional Scaling"
 
##Requirements

*RMDS* is tested on Ruby 1.8.7 and Ruby 1.9.1.

##Documentation

An up-to-date documentation of the current master branch can be found [here](http://rdoc.info/github/cheind/rmds/master/frames).

##License

*RMDS* is copyright 2010 Christoph Heindl. It is free software, and may be redistributed under the terms specified in the {file:LICENSE.md} file.
