test_that("psi_equation returns NA when b is zero", {
  expect_true(is.na(psi_equation(a = 0, b = 0, diagonal = TRUE)))
  expect_true(is.na(psi_equation(a = 1, b = 0, diagonal = TRUE)))
})

test_that("`psi_distance_lock_step()` errors on unequal-length series", {
  x <- zoo_simulate(name = "x", rows = 10, seed = 1)
  y <- zoo_simulate(name = "y", rows = 20, seed = 2)
  expect_error(
    psi_distance_lock_step(x = x, y = y, distance = "euclidean"),
    "same number of rows"
  )
})

test_that("`psi_...()` works", {

  d <- "euclidean"

  diagonal <- TRUE

  x <- zoo_simulate(
    name = "x",
    rows = 20,
    seasons = 1,
    seed = 1
    )

  expect_true(zoo::is.zoo(x))
  expect_true(nrow(zoo::coredata(x)) == 20)

  y <- zoo_simulate(
    name = "y",
    rows = 30,
    seasons = 1,
    seed = 2
    )

  expect_true(zoo::is.zoo(y))
  expect_true(nrow(zoo::coredata(y)) == 30)

  dist_matrix <- psi_distance_matrix(
    x = x,
    y = y,
    distance = d
    )

  expect_true(is.matrix(dist_matrix))
  expect_true(ncol(dist_matrix) == 20)
  expect_true(nrow(dist_matrix) == 30)


  cost_matrix <- psi_cost_matrix(
    dist_matrix = dist_matrix,
    diagonal = diagonal
    )

  expect_true(is.matrix(cost_matrix))
  expect_equal(dim(dist_matrix), dim(cost_matrix))


  cost_path <- psi_cost_path(
    dist_matrix = dist_matrix,
    cost_matrix = cost_matrix,
    diagonal = diagonal
  )

  expect_true(is.data.frame(cost_path))
  expect_equal(colnames(cost_path), c("x", "y", "dist", "cost"))

  a <- psi_cost_path_sum(path = cost_path)

  expect_true(is.numeric(a))

  b <- psi_auto_sum(
    x = x,
    y = y,
    distance = d
    )

  expect_true(is.numeric(b))

  psi <- psi_equation(
    a = a,
    b = b,
    diagonal = diagonal
    )

  expect_true(is.numeric(psi))

  #compare with distantia
  expect_equal(
    distantia(
      tsl = list(x = x, y = y),
      distance = d
      )$psi,
    psi
    )

})
