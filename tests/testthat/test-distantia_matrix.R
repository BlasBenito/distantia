test_that("`distantia_matrix()` works", {
  tsl <- tsl_aggregate(
    tsl_subset(tsl_initialize(
      x = covid_prevalence,
      name_column = "name", time_column = "time"
    ), names = 1:5),
    new_time = "months", method = sum
  )
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl, guide_columns = 3)
    dev.off()
  }, )
  distantia_df <- distantia(tsl = tsl, lock_step = c(TRUE, FALSE))
  distantia_matrix <- distantia_matrix(df = distantia_df)
  expect_equal(lapply(X = distantia_matrix, FUN = class), )
  expect_equal(lapply(X = distantia_matrix, FUN = function(x) attributes(x)$distantia_args), )
  expect_equal(if (interactive()) {
    utils_matrix_plot(m = distantia_matrix)
    utils_matrix_plot(m = distantia_matrix[[2]])
  }, )
})
