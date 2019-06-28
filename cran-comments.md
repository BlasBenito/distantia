## Test environments
* Local: Ubuntu 18.04.2 LTS, R 3.6.0
* Rhub
  * macOS 10.11 El Capitan, R-release
  * Ubuntu Linux 16.04 LTS, R-devel
  * Ubuntu Linux 16.04 LTS, R-release
  * Windows Server 2008 R2 SP1, R-release, 32/64 bit
  * Windows Server 2008 R2 SP1, R-oldrel, 32/64 bit
  * Windows Server 2008 R2 SP1, R-devel, 32/64 bit
* win-builder (devel, release, oldrelease)


## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE: 

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Blas M. Benito <blasbenito@gmail.com>'
New submission

Possibly mis-spelled words in DESCRIPTION:

  Birks (8:201)
  
  
The word "Birks" is not mis-spelled.

## Resubmission

This is a resubmission. First submission failed because win-builder checks yielded the NOTE:

* checking top-level files ... NOTE
Non-standard file/directory found at top level:
  ‘cran-comments.md’
  
I added the file correctly to .Rbuildignore

## Second Resubmission

This is a resubmission. Second submission failed because win-builder checks found that the field "License" was missing from the DESCRIPTION file. I have added the string "License: GPL (>= 2)" to DESCRIPTION.

## Third Resubmission

Fixed minor things in the DESCRIPTION file, replaced dontrun with donttest.

## Fourth Resubmission

Fixed a small bug in prepareSequences, removed messages produced by prepareSequences, fixed an issue with par() not reseting after running an example in leastCostMatrix, and fixed the example of the autoSum function to avoid using more than one processor.
