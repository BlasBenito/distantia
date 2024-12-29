test_that("`distantia_time_shift()` works", {

  tsl <- tsl_transform(
    tsl_transform(
      tsl_init(x = cities_temperature[cities_temperature$name %in%
      c("London", "Kinshasa"), ], name = "name", time = "time"),
    f = f_scale_local
  ),
  f = f_detrend_poly,
  degree = 35
  )

  df_shift <- distantia_time_shift(
    tsl = tsl,
    two_way = TRUE
    )

  expect_equal(nrow(df_shift), 2)

  df_shift <- distantia_time_shift(
    tsl = tsl,
    two_way = FALSE
  )

  expect_equal(nrow(df_shift), 1)

  expect_true(all(colnames(df_shift) %in% c("x", "y", "distance", "units", "mean", "min", "q1", "median", "q3", "max", "sd", "range", "modal")))

})
