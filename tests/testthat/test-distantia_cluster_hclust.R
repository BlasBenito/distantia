test_that("`distantia_cluster_hclust()` works", {

   tsl <- tsl_initialize(
    x = covid_prevalence,
    name_column = "name",
    time_column = "time"
  )

  tsl <- tsl_subset(tsl = tsl, names = 1:10)

  distantia_df <- distantia(
    tsl = tsl,
    lock_step = TRUE
    )

  distantia_clust <- distantia_cluster_hclust(
    df = distantia_df,
    clusters = NULL,
    method = NULL
  )

  expect_equal(names(distantia_clust), c("cluster_object", "clusters", "silhouette_width", "df", "d", "optimization"))

  expect_true(class(distantia_clust$cluster_object) == "hclust")

  expect_true(class(distantia_clust$d) == "dist")

  expect_true(class(distantia_clust$df) == "data.frame")

  expect_true(is.numeric(distantia_clust$silhouette_width))

})
