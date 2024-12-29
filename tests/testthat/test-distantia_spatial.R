test_that("`distantia_spatial()` works", {

  tsl <- distantia::tsl_initialize(
    x = distantia::covid_prevalence,
    name_column = "name", time_column = "time"
  )

  df_psi <- distantia::distantia_ls(tsl = tsl)

  sf_psi <- distantia::distantia_spatial(
    df = df_psi, sf = distantia::covid_counties,
    network = TRUE
  )

  expect_true("sf" %in% class(sf_psi))

  expect_equal(nrow(df_psi), nrow(sf_psi))

})
