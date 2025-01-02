test_that("`tsl_colnames_clean()` works", {

  tsl <- tsl_simulate(cols = 3,
                      seed = 1)

  # tsl_colnames_set ----
  tsl <- tsl_colnames_set(
    tsl = tsl,
    names = c("New name 1", "new Name 2", "NEW NAME 3")
    )

  expect_equal(
    unique(unlist(tsl_colnames_get(tsl = tsl, names = "all"))),
    c("New name 1", "new Name 2", "NEW NAME 3")
    )

  # tsl_colnames_clean ----
   tsl <- tsl_colnames_clean(tsl = tsl)

   expect_true(
     all(
     unique(unlist(tsl_colnames_get(tsl = tsl, names = "all"))) %in%
     utils_clean_names(x = c("New name 1", "new Name 2", "NEW NAME 3"))
     )
   )

  tsl <- tsl_colnames_clean(
    tsl = tsl,
    capitalize_first = TRUE,
    length = 6,
    suffix = "clean"
  )

  expect_true(
    all(
      unique(unlist(tsl_colnames_get(tsl = tsl, names = "all"))) %in%
        utils_clean_names(x = c("New name 1", "new Name 2", "NEW NAME 3"), length = 6, capitalize_first = TRUE, suffix = "clean")
    )
  )

  #tsl_colnames_get ----

  names(tsl[[1]])[1] <- "new_column"

  expect_true(
    "new_column" %in%
    unique(unlist(tsl_colnames_get(tsl = tsl, names = "all")))
    )

  expect_true(
    "new_column" %in%
      unique(unlist(tsl_colnames_get(tsl = tsl, names = "exclusive")))
  )

  expect_true(
    !"new_column" %in%
      unique(unlist(tsl_colnames_get(tsl = tsl, names = "shared")))
  )

  #tsl_colnames_prefix ----
  tsl <- tsl_colnames_prefix(tsl = tsl, prefix = "my_prefix_")

  expect_true(
    "my_prefix_new_column" %in%
      unique(unlist(tsl_colnames_get(tsl = tsl, names = "all")))
  )

  #tsl_colnames_set ----
  tsl <- tsl_colnames_set(
    tsl = tsl,
    names = c("x", "y", "z", "zz")
    )

  expect_equal(
    unique(unlist(tsl_colnames_get(tsl = tsl))), c("x", "y", "z")
    )


  tsl <- tsl_colnames_set(
    tsl = tsl,
    names = list(
      A = c("A", "B", "C"),
      B = c("X", "Y", "Z", "ZZ")
      )
    )
  expect_equal(tsl_colnames_get(tsl = tsl)$A, c("A", "B", "C"))
  expect_equal(tsl_colnames_get(tsl = tsl)$B, c("X", "Y", "Z"))

  #tsl_colnames_suffix
  tsl <- tsl_colnames_suffix(tsl = tsl, suffix = "_my_suffix")

  expect_equal(
    tsl_colnames_get(tsl = tsl)$A,
    paste0(c("A", "B", "C"), "_my_suffix")
    )
})
