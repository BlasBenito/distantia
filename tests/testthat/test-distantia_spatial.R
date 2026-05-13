test_that("`distantia_spatial()` produces a valid sf network", {

  tsl <- distantia::tsl_initialize(
    x = distantia::covid_prevalence,
    name_column = "name", time_column = "time"
  )

  df_psi <- distantia::distantia_ls(tsl = tsl)

  sf_psi <- distantia::distantia_spatial(
    df = df_psi, sf = distantia::covid_counties,
    network = TRUE
  )

  # correct class
  expect_true(inherits(sf_psi, "sf"))

  # row count preserved
  expect_equal(nrow(df_psi), nrow(sf_psi))

  # required columns exist
  expect_true("edge_name" %in% colnames(sf_psi))
  expect_true("length"    %in% colnames(sf_psi))

  # intermediate id columns must not leak into output
  expect_false(any(c("id", "id_x", "id_y", "id.x", "id.y") %in% colnames(sf_psi)))

  # all linestring lengths are positive (confirms ids were resolved correctly)
  expect_true(all(sf_psi$length > 0))

  # geometry type is LINESTRING
  expect_equal(
    unique(as.character(sf::st_geometry_type(sf_psi))),
    "LINESTRING"
  )

})

test_that("`distantia_spatial()` warns on identical coordinates (zero-length linestring)", {

  tsl2 <- tsl_initialize(
    x = fagus_dynamics,
    name_column = "name",
    time_column = "time"
  )[c("Germany", "Spain")]

  df <- distantia_ls(tsl = tsl2)

  sf_dup <- sf::st_as_sf(
    data.frame(name = c("Germany", "Spain"), x = c(10.0, 10.0), y = c(51.0, 51.0)),
    coords = c("x", "y"),
    crs = 4326
  )

  expect_warning(
    distantia_spatial(df = df, sf = sf_dup),
    regexp = "zero-length",
    fixed = FALSE
  )

})

test_that("`distantia_spatial()` gives informative error when sf has no matching name column", {

  tsl2 <- tsl_initialize(
    x = fagus_dynamics,
    name_column = "name",
    time_column = "time"
  )[c("Germany", "Spain")]

  df <- distantia_ls(tsl = tsl2)

  # sf with wrong column name — no column contains "Germany" and "Spain"
  sf_bad <- sf::st_as_sf(
    data.frame(site = c("A", "B"), x = c(10.0, 11.0), y = c(51.0, 52.0)),
    coords = c("x", "y"),
    crs = 4326
  )

  expect_error(
    distantia_spatial(df = df, sf = sf_bad),
    regexp = "no column in 'sf' contains all time series names"
  )

})

test_that("`momentum_spatial()` is an alias and produces the same output", {

  tsl <- distantia::tsl_initialize(
    x = distantia::covid_prevalence,
    name_column = "name", time_column = "time"
  )

  df_psi <- distantia::distantia_ls(tsl = tsl)

  sf_via_distantia <- distantia::distantia_spatial(
    df = df_psi, sf = distantia::covid_counties,
    network = TRUE
  )

  sf_via_momentum <- distantia::momentum_spatial(
    df = df_psi, sf = distantia::covid_counties,
    network = TRUE
  )

  expect_equal(sf_via_distantia, sf_via_momentum)

})
