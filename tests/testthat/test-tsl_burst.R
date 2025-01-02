test_that("`tsl_burst()` works", {

  n = 2
  cols = 3

  tsl <- tsl_simulate(
    n = n,
    time_range = c("2010-01-01", "2024-12-31"),
    cols = cols,
    seed = 1
  )


  tsl_ <- tsl_burst(tsl)

  expect_true(
    length(tsl_) == n * cols
  )

  expect_true(
    unique(unlist(tsl_colnames_get(tsl = tsl_))) == "x"
  )

})
