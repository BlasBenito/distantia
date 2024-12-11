test_that("`distantia_to_sf()` works", {
  expect_equal(data("fagus_dynamics"), )
  expect_equal(data("fagus_coordinates"), )
  tsl <- tsl_transform(tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  ), f = f_scale_global)
  distantia_df <- distantia(tsl = tsl)
  distantia_sf <- distantia::distantia_to_sf(
    df = distantia_df,
    xy = fagus_coordinates
  )
  importance_df <- distantia_importance(tsl = tsl)
  importance_sf <- distantia::distantia_to_sf(
    df = importance_df,
    xy = fagus_coordinates
  )
  expect_equal(names(importance_sf), )
})
