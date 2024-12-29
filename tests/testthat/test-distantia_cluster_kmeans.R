test_that("`distantia_cluster_kmeans()` works", {

  tsl <- tsl_initialize(
    x = covid_prevalence,
    name_column = "name",
    time_column = "time"
  )

  tsl <- tsl_subset(tsl = tsl, names = 1:10)

  distantia_df <- distantia(tsl = tsl, lock_step = TRUE)

  distantia_kmeans <- distantia_cluster_kmeans(
    df = distantia_df,
    clusters = NULL
  )

  expect_equal(names(distantia_kmeans), c("cluster_object", "clusters", "silhouette_width", "df", "d", "optimization"))

  expect_true(class(distantia_kmeans$cluster_object) == "kmeans")

  expect_true("matrix" %in% class(distantia_kmeans$d))

  expect_true(class(distantia_kmeans$df) == "data.frame")

  expect_true(is.numeric(distantia_kmeans$silhouette_width))

})
