suppressWarnings(library(testthat))


# Setup -------------------------------------------------------------------

# Nothing here!

# Tests -------------------------------------------------------------------

test_that("Table is formed as expected", {

  # At _least_ as many rows as we started with
  expect_gte(
    nrow(org_resolver),
    911
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


test_that("Bulk test of organisation resolution", {

  # This is a list of known good resolutions - we only test that it resolves
  # ids because otherwise, tests will fail when we update the names of
  # organisations

  test_names <- read.csv(test_path("testdata", "validation-names.csv"))

  # Test that everything resolves as expected
  expect_equal(
    resolve_name(test_names$identifier, lang = "id"),
    test_names$id
  )

})
