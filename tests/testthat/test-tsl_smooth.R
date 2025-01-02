test_that("`tsl_smooth()` works", {

  tsl <- tsl_simulate(n = 2,
                      seed = 1)

  tsl_sd <- tsl_stats(tsl = tsl)$sd

  tsl_smooth <- tsl_smooth(tsl = tsl, window = 5, f = mean)

  tsl_smooth_sd <- tsl_stats(tsl = tsl_smooth)$sd

  expect_true(
    all(
      tsl_sd > tsl_smooth_sd
    )
  )

})
