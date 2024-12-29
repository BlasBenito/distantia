test_that("`distance_matrix()` works", {
  m <- distance_matrix(
    df = cities_coordinates,
    name_column = "name",
    distance = "euclidean"
  )
  expect_equal(attributes(m)$distance, "euclidean")
  expect_equal(ncol(m), nrow(cities_coordinates))
  expect_equal(nrow(m), nrow(cities_coordinates))
})
