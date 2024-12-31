export _R_CHECK_CRAN_INCOMING_=TRUE
export _R_CHECK_FORCE_SUGGESTS_=TRUE
export _R_CHECK_VIGNETTES_NLINES_=10000
export R_USE_VALGRIND=1
export VALGRIND_OPTS="--leak-check=full --track-origins=yes"
R CMD check --as-cran --use-valgrind /home/blas/Dropbox/GITHUB/R_packages/distantia_2.0.0.tar.gz
