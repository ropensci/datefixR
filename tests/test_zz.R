library(testthat)
if (Sys.info()[["sysname"]] == "Darwin") {
  test_that("Warning if multibyte support is not detected", {
    withr::with_locale(new = c("LC_CTYPE" = "en_US.US-ASCII"), code = {
      expect_message(library(datefixR), paste0(
        "The current locale does not support multibyte characters. ",
        "You may run into difficulties if any months are given as ",
        "non-English language names. \n"
      ))
    })
  })
}
