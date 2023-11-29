# Test cases for the individual distance functions
testthat::test_that("Distance Metrics", {

  x <- runif(10)
  y <- runif(10)

  methods <- c(
    "euclidean",
    "euc",
    "manhattan",
    "man",
    "chi",
    "hellinger",
    "hel",
    "canberra",
    "can",
    "russelrao",
    "rus",
    "cosine",
    "cos",
    "jaccard",
    "jac",
    "chebyshev",
    "che"
  )

  for(method.i in methods){

    d <- distance(x, y, method = method.i)

    testthat::expect_true(
      is.numeric(d)
    )

  }

})
