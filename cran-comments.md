# `distantia` version 2.0.0

Full re-write of most computationally demanding functions with Rcpp.

## Local check

```bash
export VALGRIND_OPTS="--leak-check=full --track-origins=yes"
R CMD check --as-cran --use-valgrind distantia_2.0.0.tar.gz


```

## `devtools::check(document = FALSE)`

The check returns one NOTE because the libs subdirectory is then above the 1MB threshold. 

```r
── R CMD check results ───────────────────────────────────────── distantia 2.0.0 ────
Duration: 3m 5.4s

❯ checking installed package size ... NOTE
    installed size is 11.2Mb
    sub-directories of 1Mb or more:
      libs   9.5Mb

0 errors ✔ | 0 warnings ✔ | 1 note ✖

R CMD check succeeded
```

My understanding is that this inflation of the libs subdirectory is due to the use of Rcpp. Indeed, some functions of the `distantia` package have been written in C++ using Rcpp. They are needed to perform dynamic time warping and other critical operations efficiently. 




  + Local check and tests performed in Ubuntu 20.04.6 LTS (Focal) on R 4.4.1: 0 errors, warnings, and notes.
  + Platform checks performed with rhub::rhub_check() for all available setups:
    + "linux"
    + "macos"
    + "macos-arm64"
    + "windows"
    + "atlas"
    + "c23"
    + "clang-asan"
    + "clang16"
    + "clang17"
    + "clang18"
    + "clang19"
    + "gcc13"
    + "gcc14"
    + "intel"
    + "mkl"
    + "nold"
    + "nosuggests"
    + "ubuntu-clang"
    + "ubuntu-gcc12"
    + "ubuntu-next"
    + "ubuntu-release"
    + "valgrind"


## R CMD check results
0 errors ✔ | 0 warnings ✔ | 0 notes ✔
