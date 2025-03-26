suppressWarnings(library(testthat))


# Setup -------------------------------------------------------------------

# Nothing here!

# Tests -------------------------------------------------------------------

test_that("Table is formed as expected", {

  # At _least_ as many rows as we started with
  expect_gte(
    nrow(org_resolver),
    789
  )

  # Six columns
  expect_equal(
    ncol(org_resolver),
    6
  )

  # No missing values
  expect_equal(
    sum(is.na(unlist(org_resolver[,1:ncol(org_resolver)]))),
    0
  )

  # Each identifier should only be listed once
  expect_false(
    any(table(org_resolver$identifier) > 1)
  )

})
