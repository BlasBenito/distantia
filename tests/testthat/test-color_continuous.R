test_that("`color_continuous()` works", {
  expect_equal(length(color_continuous(n = 1)), 1)
  expect_equal(length(color_continuous(n = 10)), 10)
  expect_equal(length(color_continuous(n = 100)), 100)
})
