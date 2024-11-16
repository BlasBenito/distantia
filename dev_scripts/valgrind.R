# https://www.r-bloggers.com/2020/06/testing-rcpp-packages/
#https://francoismichonneau.net/2014/03/how-to-do-ubsan-tests-r-package/

#https://stackoverflow.com/questions/76181893/cant-solve-valgrind-memory-issues-in-rcpp-code

#TIPS
# Do not turn on leak checking initially.
# Fix all errors from the top down.
# When you have no more errors, turn on leak checking.
# Fix the leaks from the bottom up (the largest leaks are at the end).

#build source
devtools::build()

#test as cran
R CMD check --as-cran --use-valgrind /home/blas/Dropbox/GITHUB/R_packages/distantia_2.0.0.tar.gz

#run specific file
R -d valgrind --vanilla > tests/myTest1.R

#specific test file
R -d "valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes" -f tests/testthat/test-auto_sum.R

#full test
R -d "valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes" -e "devtools::test()"

