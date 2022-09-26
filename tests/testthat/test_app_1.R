# This file is for testing the applications in the apps/ directory.

test_that("fix_date_app() works", {
  # Don't run these tests on the CRAN build servers
  skip_on_cran()
  skip_if_not(Sys.info()["sysname"] == "Darwin", message = "Not run on macOS")
  withr::local_package("shinytest")

  expect_pass(testApp(test_path("apps/fix_date_theme/"), compareImages = TRUE))
})
