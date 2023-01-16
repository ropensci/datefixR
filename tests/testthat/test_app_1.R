# This file is for testing the applications in the apps/ directory.

test_that("fix_date_app() works with datefixR theme", {
  # Don't run these tests on the CRAN build servers
  skip_on_cran()
  skip_if_not(Sys.info()["sysname"] == "Darwin", message = "Not run on macOS")
  withr::local_package("shinytest2")
  shiny_app <- fix_date_app()
  app <- AppDriver$new(shiny_app, variant = platform_variant())
  app$set_window_size(width = 779, height = 853)
  # Uploaded file outside of: ./tests/testthat
  app$upload_file(datafile = system.file("example.xlsx", package = "datefixR"))
  app$click("do")
  # Update output value
  # Update unbound `input` value
  app$set_inputs(`selected.columns` = "Apple")
  app$set_inputs(`selected.columns` = c("Apple", "Pear"))
  app$set_inputs(`selected.columns` = c("Apple", "Pear", "Lemon"))
  app$click("do")
  # Update output value
  # Update unbound `input` value
  app$expect_screenshot(threshold = 1)
  app$set_inputs(`selected.columns` = "Apple")
  app$set_inputs(`selected.columns` = c("Apple", "Pear"))
  app$click("do")
  # Update output value
  app$expect_screenshot(threshold = 1)
})

test_that("fix_date_app() works with shiny theme", {
  # Don't run these tests on the CRAN build servers
  skip_on_cran()
  skip_if_not(Sys.info()["sysname"] == "Darwin", message = "Not run on macOS")
  withr::local_package("shinytest2")
  shiny_app <- fix_date_app(theme = "none")

  app2 <- AppDriver$new(shiny_app, variant = "shiny")
  app2$set_window_size(width = 779, height = 853)
  # Uploaded file outside of: ./tests/testthat
  app2$upload_file(datafile = system.file("example.csv", package = "datefixR"))
  app2$click("do")
  # Update output value
  # Update unbound `input` value
  app2$set_inputs(`selected.columns` = "Apple")
  app2$set_inputs(`selected.columns` = c("Apple", "Pear"))
  app2$set_inputs(`selected.columns` = c("Apple", "Pear", "Lemon"))
  app2$click("do")
  # Update output value
  # Update unbound `input` value
  app2$expect_screenshot(threshold = 1)
  app2$set_inputs(`selected.columns` = "Apple")
  app2$set_inputs(`selected.columns` = c("Apple", "Pear"))
  app2$click("do")
  # Update output value
  app2$expect_screenshot(threshold = 1)
})
