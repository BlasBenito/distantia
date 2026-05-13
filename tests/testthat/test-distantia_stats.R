test_that("`distantia_stats()` returns one row per time series with expected columns", {
  tsl <- tsl_simulate(n = 4, irregular = FALSE)

  df <- distantia(tsl = tsl, lock_step = TRUE)

  out <- distantia_stats(df = df)

  expect_equal(class(out), "data.frame")
  expect_equal(nrow(out), length(tsl))
  expect_true(all(c("name", "mean", "min", "q1", "median", "q3", "max", "sd", "range") %in% colnames(out)))
  expect_true(all(is.numeric(out$mean)))
  expect_true(all(out$range >= 0))
})

test_that("`distantia_stats()` warns on NA psi and still returns stats", {
  tsl <- tsl_simulate(n = 3, irregular = FALSE)

  df <- distantia(tsl = tsl, lock_step = TRUE)

  # inject an NA psi to simulate a flat/constant series edge case
  df$psi[1] <- NA

  expect_warning(
    out <- distantia_stats(df = df),
    regexp = "NA psi"
  )

  expect_equal(class(out), "data.frame")
  expect_true(all(!is.na(out$mean)))
})

test_that("`distantia_aggregate()` works with multiple parameter combinations", {
  tsl <- tsl_simulate(n = 3, irregular = FALSE)

  # lock_step = c(TRUE, FALSE) ensures 'diagonal' column is present, triggering
  # the multi-combo aggregate path (the original bug: aggregate(x=df, by=formula))
  df <- distantia(tsl = tsl, distance = c("euclidean", "manhattan"), lock_step = c(TRUE, FALSE))

  out <- distantia_aggregate(df = df, f = mean)

  expect_equal(class(out), "data.frame")
  expect_true("psi" %in% colnames(out))
  expect_true("x" %in% colnames(out))
  expect_true("y" %in% colnames(out))
  # one row per pair (3 pairs for 3 time series, all combos collapsed)
  expect_equal(nrow(out), 3L)
})
