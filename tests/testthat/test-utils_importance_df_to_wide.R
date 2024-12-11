test_that("`utils_importance_df_to_wide()` works", {
  expect_equal(data("fagus_dynamics"), )
  tsl <- tsl_transform(tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  ), f = f_scale_global)
  df <- distantia_importance(tsl = tsl)
  expect_equal(df, )
  df_wide <- utils_importance_df_to_wide(df = df)
  expect_equal(df_wide, )
})
