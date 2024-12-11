test_that("`distantia_plot()` works", {
  tsl <- tsl_transform(tsl_initialize(
    x = fagus_dynamics, name_column = "name",
    time_column = "time"
  ), f = f_scale_global)
  expect_equal(if (interactive()) {
    tsl_plot(tsl = tsl, guide_columns = 3)
  }, )
  expect_equal(if (interactive()) {
    distantia_plot(tsl = tsl[c("Spain", "Sweden")])
    distantia_plot(tsl = tsl[c("Spain", "Sweden")], matrix_type = "distance")
    distantia_plot(
      tsl = tsl[c("Spain", "Sweden")], distance = "manhattan",
      matrix_type = "distance"
    )
    distantia_plot(
      tsl = tsl[c("Spain", "Sweden")], matrix_type = "distance",
      matrix_color = grDevices::hcl.colors(n = 100, palette = "Inferno"),
      path_color = "white", path_width = 2, line_color = grDevices::hcl.colors(
        n = 3,
        palette = "Inferno"
      )
    )
  }, )
})
