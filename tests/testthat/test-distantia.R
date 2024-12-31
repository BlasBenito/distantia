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
  block_size <- c(3, 6)
  repetitions <- 10
  seed <- c(1, 2)

  #distantia output only
  df <- distantia(
    tsl = tsl,
    distance = distance,
    diagonal = diagonal,
    bandwidth = bandwidth,
    lock_step = lock_step,
    permutation = permutation,
    block_size = block_size,
    repetitions = repetitions,
    seed = seed
  )

  expect_true(all(c("x", "y", "distance", "diagonal", "bandwidth", "lock_step", "repetitions", "permutation", "block_size", "seed", "psi", "p_value", "null_mean", "null_sd") %in% colnames(df)))

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

  #check for invalid combinations of permutation and block_size
  expect_true(
    nrow(
      df[df$permutation %in% c("free", "free_by_row") & !is.na(df$block_size),]
    ) == 0
  )

  expect_true(all(names(tsl) %in% unique(c(df$x, df$y))))

  expect_true(
    all(df[df$x == "Germany" & df$y == "Sweden", "psi"] < df[df$x == "Spain" & df$y == "Sweden", "psi"])
  )

  #reproduce p-values
  psi_null <- psi_null_dtw_cpp(
    x = tsl[["Spain"]],
    y = tsl[["Sweden"]],
    distance = "euclidean",
    repetitions = 10,
    permutation = "restricted_by_row",
    block_size = 3,
    seed = 1
  )

  expect_equal(
    mean(psi_null),
    df[
      df$x == "Spain" &
        df$y == "Sweden" &
        df$distance == "euclidean" &
        df$diagonal == TRUE &
        df$bandwidth == 1 &
        df$lock_step == FALSE &
        df$permutation == "restricted_by_row" &
        df$block_size == 3 &
        df$seed == 1,
      "null_mean"
      ]
    )

 #compare with distantia with no repetitions
 df_distantia <- distantia(
   tsl = tsl,
   repetitions = 0
 )

 df_distantia <- df_distantia[, c("x", "y", "psi")]

 rownames(df_distantia) <- NULL

 df_test <- df[df$lock_step == FALSE & df$diagonal == TRUE & df$bandwidth == 1 & df$permutation == "free" & df$seed == 1 & df$distance == "euclidean", c("x", "y", "psi")]

 rownames(df_test) <- NULL

 expect_true(all.equal(df_distantia, df_test))

 #compare with distantia ls
  df_ls <- distantia_ls(
    tsl = tsl
  )

  df_ls <- df_ls[, c("x", "y", "psi")]

  rownames(df_ls) <- NULL

  df_test <- df[df$lock_step == TRUE & df$permutation == "free" & df$seed == 1 & df$distance == "euclidean", c("x", "y", "psi")]

  rownames(df_test) <- NULL

  expect_true(all.equal(df_ls, df_test))

  #compare with distantia_dtw
  df_dtw <- distantia_dtw(
    tsl = tsl
  )

  df_dtw <- df_dtw[, c("x", "y", "psi")]

  rownames(df_dtw) <- NULL

  df_test <- df[df$lock_step == FALSE & df$diagonal == TRUE & df$bandwidth == 1 & df$permutation == "free" & df$seed == 1 & df$distance == "euclidean", c("x", "y", "psi")]

  rownames(df_test) <- NULL

  expect_true(all.equal(df_dtw, df_test))

  #test distantia aggregate
  df_agg <- distantia_aggregate(
    df = df
  )

  expect_true(
    nrow(df_agg) == 3
  )

  expect_true(all(c("x", "y", "psi") %in% colnames(df_agg)))

  #test distantia stats
  df_stats <- distantia_stats(
    df = df
  )

  expect_true(
    nrow(df_stats) == 3
  )

  expect_true(all(c("name", "mean", "min", "q1", "median", "q3", "max", "sd", "range") %in% colnames(df_stats)))

})
