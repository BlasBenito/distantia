test_that("Functions `distantia()`, `distantia_ls()`, and `distantia_dtw()` work.", {

  #short multivariate tsl for testing
  tsl <- tsl_initialize(
    x = fagus_dynamics,
    name_column = "name",
    time_column = "time"
  ) |>
    tsl_subset(
      time = c("2010-01-01", "2011-01-01")
    ) |>
    tsl_transform(
      f = f_scale_global
      )

  #params
  distance = c("euclidean", "manhattan")
  permutation = c(
    "restricted_by_row",
    "restricted",
    "free_by_row",
    "free"
    )
  diagonal <- c(TRUE, FALSE)
  bandwidth <- c(1, 0.5)
  lock_step <- c(TRUE, FALSE)
  robust <- c(TRUE, FALSE)

  #distantia output only
  #message about robust having two values
  testthat::expect_message(
    df <- momentum(
      tsl = tsl,
      distance = distance,
      diagonal = diagonal,
      bandwidth = bandwidth,
      lock_step = lock_step,
      robust = robust
    )
  )

  expect_true(all(c("x", "y", "psi", "variable", "importance", "effect", "psi_difference", "psi_without", "psi_only_with", "distance", "diagonal", "bandwidth", "lock_step", "robust") %in% colnames(df)))

  #check for invalid combinations with lock_step
  expect_true(
    nrow(
      df[df$lock_step == TRUE & !is.na(df$diagonal),]
    ) == 0
  )

  expect_true(
    nrow(
      df[df$lock_step == TRUE & !is.na(df$bandwidth),]
    ) == 0
  )

  expect_true(all(names(tsl) %in% unique(c(df$x, df$y))))

  expect_true(
    all(df[df$x == "Germany" & df$y == "Sweden", "psi"] < df[df$x == "Spain" & df$y == "Sweden", "psi"])
  )

 #compare with momentum ls
  df_ls <- momentum_ls(
    tsl = tsl
  )

  df_ls <- df_ls[, c("x", "y", "variable", "importance")]

  rownames(df_ls) <- NULL

  df_test <- df[df$lock_step == TRUE & df$distance == "euclidean", c("x", "y", "variable", "importance")]

  rownames(df_test) <- NULL

  expect_true(all.equal(df_ls, df_test))

  #compare with distantia_dtw
  df_dtw <- momentum_dtw(
    tsl = tsl
  )

  df_dtw <- df_dtw[, c("x", "y", "variable", "importance")]

  rownames(df_dtw) <- NULL

  df_test <- df[df$lock_step == FALSE & df$diagonal == TRUE & df$bandwidth == 1 &  df$distance == "euclidean", c("x", "y", "variable", "importance")]

  rownames(df_test) <- NULL

  expect_true(all.equal(df_dtw, df_test))

  #test distantia aggregate
  df_agg <- momentum_aggregate(
    df = df
  )

  expect_true(
    nrow(df_agg) == 9
  )

  expect_true(all(c("x", "y", "variable", "psi", "importance", "psi_without", "psi_only_with") %in% colnames(df_agg)))

  #test distantia stats
  df_stats <- momentum_stats(
    df = df
  )

  expect_true(
    nrow(df_stats) == 3
  )

  expect_true(all(c("variable", "mean", "min", "q1", "median", "q3", "max", "sd", "range") %in% colnames(df_stats)))

  #momentum to wide
  df_wide <- momentum_to_wide(
    df = df
  )

  expect_true(all(c("importance__evi", "importance__rainfall", "importance__temperature") %in% colnames(df_wide)))

})
