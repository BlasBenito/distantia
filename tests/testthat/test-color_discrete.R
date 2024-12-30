test_that("`color_discrete()` works", {

  expect_equal(length(color_discrete(n = 1)), 1)
  expect_equal(length(color_discrete(n = 10)), 10)
  expect_equal(length(color_discrete(n = 100)), 100)


})
