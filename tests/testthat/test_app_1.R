# This file is for testing the applications in the apps/ directory.

test_that("fix_date_app() works with datefixR theme", {
  # Don't run these tests on the CRAN build servers
  skip_on_cran()
  skip_if_not(
    Sys.info()["sysname"] == "Darwin",
    message = "These tests only run on macOS"
  )
  withr::local_package("shinytest2")
  shiny_app <- fix_date_app()
  app <- AppDriver$new(shiny_app, variant = platform_variant())
  app$set_window_size(width = 779, height = 853)
  # Uploaded file outside of: ./tests/testthat
  app$upload_file(datafile = system.file("example.xlsx", package = "datefixR"))
  app$click("do")
  # Update output value
  app$set_inputs(
    df_rows_current = c(1, 2, 3, 4),
    allow_no_input_binding_ = TRUE,
    wait_ = FALSE
  )
  app$set_inputs(
    df_rows_all = c(1, 2, 3, 4),
    allow_no_input_binding_ = TRUE,
    wait_ = FALSE
  )
  app$set_inputs(
    df_state = c(
      1673953581559,
      0,
      10,
      "",
      TRUE,
      FALSE,
      TRUE,
      c(TRUE, "", TRUE, FALSE, TRUE),
      c(TRUE, "", TRUE, FALSE, TRUE),
      c(TRUE, "", TRUE, FALSE, TRUE),
      c(TRUE, "", TRUE, FALSE, TRUE)
    ),
    allow_no_input_binding_ = TRUE,
    wait_ = FALSE
  )
  app$set_inputs(`selected.columns` = "Apple")
  app$set_inputs(`selected.columns` = c("Apple", "Pear"))
  app$click("do")
  app$expect_values(output = TRUE)
  # Update output value
  app$set_inputs(
    df_rows_current = c(1, 2, 3, 4),
    allow_no_input_binding_ = TRUE,
    wait_ = FALSE
  )
  app$set_inputs(
    df_rows_all = c(1, 2, 3, 4),
    allow_no_input_binding_ = TRUE,
    wait_ = FALSE
  )
  app$set_inputs(
    df_state = c(
      1673953593973,
      0,
      10,
      "",
      TRUE,
      FALSE,
      TRUE,
      c(TRUE, "", TRUE, FALSE, TRUE),
      c(TRUE, "", TRUE, FALSE, TRUE),
      c(TRUE, "", TRUE, FALSE, TRUE),
      c(TRUE, "", TRUE, FALSE, TRUE)
    ),
    allow_no_input_binding_ = TRUE
  )
  app$expect_download("downloadData")
  app$set_window_size(width = 779, height = 796)
  app$expect_values(output = TRUE)
})

test_that("fix_date_app() works with shiny theme", {
  # Don't run these tests on the CRAN build servers
  skip_on_cran()
  skip_if_not(
    Sys.info()["sysname"] == "Darwin",
    message = "These tests only run on macOS"
  )
  withr::local_package("shinytest2")
  shiny_app <- fix_date_app(theme = "none")
  app2 <- AppDriver$new(shiny_app, variant = "shiny")
  app2$set_window_size(width = 779, height = 853)
  # Uploaded file outside of: ./tests/testthat
  app2$upload_file(datafile = system.file("example.csv", package = "datefixR"))
  app2$click("do")
  # Update output value
  app2$set_inputs(
    df_rows_current = c(1, 2, 3, 4),
    allow_no_input_binding_ = TRUE,
    wait_ = FALSE
  )
  app2$set_inputs(
    df_rows_all = c(1, 2, 3, 4),
    allow_no_input_binding_ = TRUE,
    wait_ = FALSE
  )
  app2$set_inputs(
    df_state = c(
      1673953581559,
      0,
      10,
      "",
      TRUE,
      FALSE,
      TRUE,
      c(TRUE, "", TRUE, FALSE, TRUE),
      c(TRUE, "", TRUE, FALSE, TRUE),
      c(TRUE, "", TRUE, FALSE, TRUE),
      c(TRUE, "", TRUE, FALSE, TRUE)
    ),
    allow_no_input_binding_ = TRUE,
    wait_ = FALSE
  )
  app2$set_inputs(`selected.columns` = "Apple")
  app2$set_inputs(`selected.columns` = c("Apple", "Pear"))
  app2$click("do")
  app2$expect_values(output = TRUE)
  # Update output value
  app2$set_inputs(
    df_rows_current = c(1, 2, 3, 4),
    allow_no_input_binding_ = TRUE,
    wait_ = FALSE
  )
  app2$set_inputs(
    df_rows_all = c(1, 2, 3, 4),
    allow_no_input_binding_ = TRUE,
    wait_ = FALSE
  )
  app2$set_inputs(
    df_state = c(
      1673953593973,
      0,
      10,
      "",
      TRUE,
      FALSE,
      TRUE,
      c(TRUE, "", TRUE, FALSE, TRUE),
      c(TRUE, "", TRUE, FALSE, TRUE),
      c(TRUE, "", TRUE, FALSE, TRUE),
      c(TRUE, "", TRUE, FALSE, TRUE)
    ),
    allow_no_input_binding_ = TRUE
  )
  app2$expect_download("downloadData")
  app2$set_window_size(width = 779, height = 796)
  app2$expect_values(output = TRUE)
})
