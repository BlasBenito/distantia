test_that("`tsl_transform()` works", {

  tsl <- tsl_initialize(
    x = fagus_dynamics,
    name_column = "name",
    time_column = "time"
  ) |>
    tsl_subset(
      time = c(
        "2010-01-01",
        "2011-01-01"
        )
    )

  # f_binary ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_binary
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  #output is binary
  expect_equal(
    lapply(tsl_test, range) |>
      unlist() |>
      unique(),
    c(0, 1)
  )

  #f_rescale_global ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_rescale_global
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  #check values
  tsl_test_df <- tsl_to_df(tsl = tsl_test)
  expect_equal(
    min(tsl_test_df$temperature),
    0
  )
  expect_equal(
    max(tsl_test_df$temperature),
    1
  )
  expect_equal(
    min(tsl_test_df$evi),
    0
  )
  expect_equal(
    max(tsl_test_df$evi),
    1
  )
  expect_equal(
    min(tsl_test_df$rainfall),
    0
  )
  expect_equal(
    max(tsl_test_df$rainfall),
    1
  )

  #f_rescale_local ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_rescale_local
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  #check values
  tsl_test_stats <- tsl_stats(tsl = tsl_test)
  expect_equal(
    unique(tsl_test_stats$min),
    0
  )
  expect_equal(
    unique(tsl_test_stats$max),
    1
  )

  #f_scale_global ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_scale_global
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  tsl_test_df <- tsl_to_df(tsl = tsl_test)
  expect_equal(
    mean(tsl_test_df$temperature),
    0
  )
  expect_equal(
    sd(tsl_test_df$temperature),
    1
  )
  expect_equal(
    mean(tsl_test_df$evi),
    0
  )
  expect_equal(
    sd(tsl_test_df$evi),
    1
  )
  expect_equal(
    mean(tsl_test_df$rainfall),
    0
  )
  expect_equal(
    sd(tsl_test_df$rainfall),
    1
  )


  #f_scale_local ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_scale_local
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  #check values
  tsl_test_stats <- tsl_stats(tsl = tsl_test)
  expect_true(
    all.equal.numeric(
      target = rep(0, nrow(tsl_test_stats)),
      current = tsl_test_stats$mean
    )
  )
  expect_true(
    all.equal.numeric(
      target = rep(1, nrow(tsl_test_stats)),
      current = tsl_test_stats$sd
    )
  )

  #f_detrend_difference ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_detrend_difference
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  #f_detrend_linear ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_detrend_linear
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  #f_detrend_poly ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_detrend_poly
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  #f_trend_linear ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_trend_linear
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  #f_trend_poly ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_trend_poly
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  # Warning message:
  #   distantia::utils_prepare_time():  duplicated time indices in 'Krumbach_I':
  #   - value 6.8 replaced with 6.825
    tsl <- tsl_initialize(
      x = eemian_pollen,
      name_column = "name",
      time_column = "time"
    ) |>
      tsl_subset(
        names = 1:3
      ) |>
      suppressMessages()


  #f_clr ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_clr
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  #f_hellinger ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_hellinger
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  #f_log ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_log
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  #f_percent ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_percent
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  #f_proportion ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_proportion
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

  #f_proportion_sqrt ----
  tsl_test <- tsl_transform(
    tsl = tsl,
    f = f_proportion_sqrt
  )

  #output has same dimensions
  expect_equal(
    lapply(tsl_test, dim) |>
      unlist() |>
      unique(),
    lapply(tsl, dim) |>
      unlist() |>
      unique()
  )

  #output has no NA
  expect_equal(
    tsl_count_NA(tsl = tsl_test) |>
      unlist() |>
      unique(),
    0
  )

})
