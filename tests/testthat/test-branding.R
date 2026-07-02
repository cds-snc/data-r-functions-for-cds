suppressWarnings(library(testthat))
suppressWarnings(library(cds))


# Setup -------------------------------------------------------------------

# Nothing here!

# Tests -------------------------------------------------------------------

test_that("theme_cds() returns a ggplot theme", {
  expect_s3_class(theme_cds(), "theme")
})

test_that("colors$brand has the expected values", {
  expect_equal(unname(colors$brand[["blue"]]), "#004986")
  expect_equal(unname(colors$brand[["orange"]]), "#E87722")
})

test_that("cds_logo_path() resolves to a bundled, existing file", {
  path <- cds:::cds_logo_path()
  expect_true(file.exists(path))

  path_wordmark <- cds:::cds_logo_path(canada_wordmark = TRUE)
  expect_true(file.exists(path_wordmark))
})

test_that("add_watermark() falls back to just the date when report_name is blank", {
  plot <- ggplot2::ggplot(mtcars, ggplot2::aes(x = mpg, y = wt)) + ggplot2::geom_point()
  watermarked <- suppressWarnings(add_watermark(plot, date = as.Date("2026-01-01")))
  expect_s3_class(watermarked, "ggplot")
})
