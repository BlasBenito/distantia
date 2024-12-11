test_that("`distantia_boxplot()` works", {
  tsl <- tsl_transform(tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  ), f = f_scale_global)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl, guide_columns = 3)
  }, )
  distantia_df <- distantia(tsl = tsl)
  if (interactive()) {
    boxplot_stats <- distantia_boxplot(df = distantia_df)
    boxplot_stats
  }
  importance_df <- distantia_importance(tsl = tsl)
  if (interactive()) {
    boxplot_stats <- distantia_boxplot(df = distantia_df)
  }
})
