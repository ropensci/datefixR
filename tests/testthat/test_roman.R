test_that("check Roman numeral dates work", {
  messy.dates <- c("01 ii 2021", "2023-iv-02", "13/ix/1975")
  expect_equal(
    fix_date_char(messy.dates, roman.numeral = TRUE),
    as.Date(c("2021-02-01", "2023-04-02", "1975-09-13"))
  )
})
