# Ruby Multidimensional Scaling Library

## Introduction

*RMDS* is a library for performing multidimensional scaling. 

[Wikipedia][wiki_mds] describes multidimensional scaling (MDS) as
> [...] a set of related statistical techniques often used in information 
> visualization for exploring similarities or dissimilarities in data.

In essence, multidimensional scaling takes a matrix of similarities or dissimilarities between pairwise observations as input and outputs a matrix of observations in Cartesian coordinates that preserve the similarities/dissimilarities given. The dimensionality of the output is a parameter to the algorithm.

The following multidimensional scaling variants are offerred by *RMDS*

### Metric Multidimensional Scaling

In metric multidimensional scaling the dissimilarities are assumed to be distances. The result of this multidimensional scaling variant are coordinates in the Euclidean space that explain the given distances. In general, the embedding found is not unique. Any rotation or translation applied to found embedding does not change the pairwise distances.

For implementation and examples see {MDS::Metric}

[wiki_mds]: http://en.wikipedia.org/wiki/Multidimensional_scaling "Wikipedia - Multidimensional Scaling"

## Requirements

RMDS makes heavy use of linear algebra routines, but does not ship with linear algebra algorithms. Instead, RMDS has a non-intrusive adapter architecture to connect existing linear algebra packages to RMDS. For how-to details on providing new adapters for RMDS see {MDS::MatrixInterface}.

Note that the performance of most RMDS algorithms is dominated by the algorithms and performance of the linear algebra backend used. 

Currently the following linear algebra backends are supported

- {MDS::StdlibInterface} - Connects Ruby's core matrix class to RMDS.
- {MDS::GSLInterface} - Connects the GNU Scientific Library to RMDS.
- {MDS::LinalgInterface} - Connects LAPACK and BLAS via Linalg to RMDS.

*RMDS* is tested on Ruby 1.8.7 and partially on Ruby 1.9.1.

##Documentation

An up-to-date documentation of the current master branch can be found [here](http://rdoc.info/github/cheind/rmds/master/frames).

##License

*RMDS* is copyright 2010 Christoph Heindl. It is free software, and may be redistributed under the terms specified in the {file:LICENSE.md} file.
