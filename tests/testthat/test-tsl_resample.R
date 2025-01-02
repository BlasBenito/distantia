test_that("`tsl_resample()` works", {

  tsl <- tsl_simulate(
    n = 2,
    rows = 100,
    irregular = TRUE,
    seed = 1
    )

  expect_true(tsl_time_summary(tsl)$resolution_min != tsl_time_summary(tsl)$resolution_max)

  expect_message(
    tsl <- tsl_resample(tsl = tsl)
  ) |>
    suppressMessages()

  expect_equal(tsl_time_summary(tsl)$resolution_min, tsl_time_summary(tsl)$resolution_max)

})
