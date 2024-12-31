test_that("`tsl_transform()` works", {

  tsl <- tsl_initialize(
    x = fagus_dynamics,
    name_column = "name",
    time_column = "time"
  ) |>
    tsl_subset(
      time = c("2010-01-01", "2011-01-01")
    )

  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_binary
  )

  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )


  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_clr
  )

  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_detrend_difference
  )

  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_detrend_linear
  )


  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_detrend_poly
  )


  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_hellinger
  )


  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_log
  )


  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_percent
  )


  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_proportion
  )


  tsl_test <- tsl_transform(
    tsl = tsl,
    f = proportion_sqrt
  )

  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_rescale_global
  )

  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_rescale_local
  )

  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_scale_global
  )

  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_scale_local
  )

  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_trend_linear
  )

  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_trend_poly
  )

})
