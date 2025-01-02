test_that("`tsl_count_NA()` works", {

  tsl <- tsl_simulate()

  expect_equal(
    sum(unlist(tsl_count_NA(tsl = tsl))),
    0
    )

  tsl <- tsl_simulate()
  tsl[[1]][1, 1] <- Inf
  tsl[[1]][2, 1] <- -Inf
  tsl[[1]][3, 1] <- NaN
  tsl[[1]][4, 1] <- NaN

  expect_true(
    sum(unlist(tsl_count_NA(tsl = tsl))) == 4
  )

  tsl <- tsl_simulate(na_fraction = 0.3)

  expect_true(
    sum(unlist(tsl_count_NA(tsl = tsl))) > 0
  )

})
