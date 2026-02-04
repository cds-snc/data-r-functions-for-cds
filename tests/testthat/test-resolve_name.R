suppressWarnings(library(testthat))


# Setup -------------------------------------------------------------------

# Nothing here!

# Tests -------------------------------------------------------------------

test_that("Names resolve as expected", {

  expect_equal(
    resolve_name("IRCC", lang = "en"),
    "Immigration, Refugees and Citizenship Canada"
  )

  expect_equal(
    resolve_name("ESDC", lang = "fr"),
    "Emploi et Développement social Canada"
  )

  expect_equal(
    resolve_name("NRCAN", lang = "id"),
    "001I9000004Vt63IAC"
  )

  expect_true(
    is.na(suppressWarnings(resolve_name("Department of Unicorns")))
  )

  expect_equal(
    suppressWarnings(resolve_name(c("ESDC", "Department of Unicorns", "IRCC"))),
    c("Employment and Social Development Canada", NA, "Immigration, Refugees and Citizenship Canada")
  )
})

test_that("Warnings appear as expected", {

  expect_warning(
    resolve_name("Department of Unicorns"),
    "couldn't be matched"
  )

  expect_no_warning(
    resolve_name("Department of Unicorns", warn = FALSE)
  )

})


test_that("Language argument behaves as expected", {

  expect_equal(
    resolve_name("IRCC"),
    resolve_name("IRCC", lang = "en")
  )

  expect_equal(
    resolve_name("IRCC", lang = "english"),
    resolve_name("IRCC", lang = "en")
  )

  expect_equal(
    resolve_name("IRCC", lang = "ENGLISH"),
    resolve_name("IRCC", lang = "en")
  )

  expect_equal(
    resolve_name("IRCC", lang = "fr"),
    resolve_name("IRCC", lang = "francais")
  )

  expect_equal(
    resolve_name("IRCC", lang = "fr"),
    resolve_name("IRCC", lang = "français")
  )

  expect_equal(
    resolve_name("IRCC", lang = "fr"),
    resolve_name("IRCC", lang = "French")
  )

  expect_false(
    resolve_name("IRCC", lang = "en") ==
      resolve_name("IRCC", lang = "fr")
  )

  expect_false(
    resolve_name("IRCC", lang = "en") ==
      resolve_name("IRCC", lang = "id")
  )

  expect_error(
    resolve_name("IRCC", lang = "spanish"),
    "Unrecognized language"
  )

  expect_error(
    resolve_name("IRCC", lang = ""),
    "Unrecognized language"
  )

  expect_error(
    resolve_name("IRCC", lang = NA),
    "Unrecognized language"
  )
})


test_that("Bulk test of organisation resolution", {

  # This is a list of known good resolutions - we only test that it resolves
  # ids because otherwise, tests will fail when we update the names of
  # organisations

  validation_names <- read.csv(test_path("testdata", "validation-names.csv"))

  # Make sure the list didn't get truncated
  expect_gte(
    nrow(validation_names),
    539
  )

  # Make sure there's no missing validation data
  expect_equal(
    nrow(validation_names),
    sum(complete.cases(validation_names))
  )

  # Test that everything resolves as expected
  expect_equal(
    resolve_name(validation_names$identifier, lang = "id"),
    validation_names$id
  )

})
