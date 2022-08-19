# This file is for testing the applications in the apps/ directory.

library(shinytest)

test_that("fix_date_app() works", {
  # Don't run these tests on the CRAN build servers
  skip_on_cran()

  if (Sys.info()["sysname"] == "Darwin") {
    expect_pass(testApp(test_path("apps/fix_date_theme/"),
      compareImages = TRUE
    ))
  }
})
