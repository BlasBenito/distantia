# https://www.r-bloggers.com/2020/06/testing-rcpp-packages/

#https://stackoverflow.com/questions/76181893/cant-solve-valgrind-memory-issues-in-rcpp-code

#TIPS
# Do not turn on leak checking initially.
# Fix all errors from the top down.
# When you have no more errors, turn on leak checking.
# Fix the leaks from the bottom up (the largest leaks are at the end).

#specific test file
R -d "valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes" -f tests/testthat/test-auto_sum.R

#full test
R -d "valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes" -e "devtools::test()"

