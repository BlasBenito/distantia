export _R_CHECK_CRAN_INCOMING_=TRUE
export _R_CHECK_FORCE_SUGGESTS_=TRUE
export R_USE_VALGRIND=1
export VALGRIND_OPTS="--leak-check=full --track-origins=yes"
R CMD check --as-cran --use-valgrind /home/blas/Dropbox/blas/GITHUB/R_packages/distantia_2.0.3.tar.gz
