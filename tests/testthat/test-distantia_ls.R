test_that("`distantia_ls()` works", {

  tsl <- tsl_transform(
    tsl_initialize(
    x = fagus_dynamics,
    name_column = "name",
    time_column = "time"
  ),
  f = f_scale_global
  )


  df_ls <- distantia_ls(
    tsl = tsl,
    distance = "euclidean"
    )

  expect_true(is.data.frame(df_ls))

  expect_equal(colnames(df_ls), c("x", "y", "distance", "psi"))

})
