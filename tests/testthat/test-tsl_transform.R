test_that("`tsl_transform()` works", {
  expect_equal(future::plan(future::multisession, workers = 2), )
  tsl <- tsl_subset(tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  ), names = c("Spain", "Sweden"), colnames = c(
    "rainfall",
    "temperature"
  ))
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl)
  }, )
  tsl_scale <- tsl_transform(tsl = tsl, f = f_scale_local)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl_scale, guide_columns = 3)
  }, )
  tsl_rescaled <- tsl_transform(
    tsl = tsl, f = f_rescale_local,
    new_min = -100, new_max = 100
  )
  expect_equal(sapply(X = tsl, FUN = range), )
  expect_equal(sapply(X = tsl_rescaled, FUN = range), )
  tsl_pca <- tsl_transform(tsl_transform(tsl, f = f_scale_global),
    f = f_pca
  )
  expect_equal(tsl_colnames_get(tsl = tsl_pca), )
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl_pca, guide_columns = 3)
  }, )
  tsl <- tsl_initialize(
    x = eemian_pollen, name_column = "name",
    time_column = "time"
  )
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl)
  }, )
  tsl_percentage <- tsl_transform(tsl = tsl, f = f_percentage)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl_percentage)
  }, )
  tsl_hellinger <- tsl_transform(tsl = tsl, f = f_hellinger)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl_hellinger)
  }, )
  expect_equal(future::plan(future::sequential), )
})
