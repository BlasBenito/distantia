usethis::use_testthat()
usethis::use_test("distance.R")

#distance.R
testthat::test_file("tests/testthat/test-distance.R")
