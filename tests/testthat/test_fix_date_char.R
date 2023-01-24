test_that("fix_date_char works for a series of malformed dates", {
  dates <- c(
    "02 03 2021" = "2021-03-02",
    "15/07/11"   = "2011-07-15",
    "15/07/84"   = "1984-07-15",
    "2015 11 11" = "2015-11-11",
    "05/2015"    = "2015-05-01",
    "2020-01"    = "2020-01-01",
    "05/89"      = "1989-05-01",
    "02/14"      = "2014-02-01",
    "1994"       = "1994-07-01"
  )

  fixed <- fix_date_char(names(dates))

  expect_equal(fixed, as.Date(unname(dates)))
})

test_that("fix_date returns NA if NA is given", {
  bad.date <- NA
  fixed.date <- fix_date_char(bad.date)
  expect_equal(fixed.date, as.Date(NA))
})

test_that("error if date given isn't character", {
  bad.date <- 15
  expect_error(fix_date_char(bad.date), "date should be a character \n")
})

test_that("error if date given has over 4 digits for year", {
  bad.date <- "202312-12-2"
  expect_error(fix_date_char(bad.date), "unable to tidy a date")
})

test_that("Test NA imputed when provided", {
  bad.date <- "1990-5"
  expect_warning(
    date.guess <- fix_date_char(bad.date, day.impute = NA),
    "NA imputed"
  )
  expect_equal(date.guess, as.Date(NA))
})

test_that("fix_date works for mdy format", {
  bad.date <- "07/15/11"
  fixed.date <- fix_date_char(bad.date, format = "mdy")
  expect_equal(fixed.date, as.Date("2011-07-15"))
})

test_that("unexpected format raises error", {
  bad.date <- "07/15/11"
  expect_error(
    fix_date_char(bad.date, format = "ydm"),
    "format should be either 'dmy' or 'mdy' \n"
  )
})

test_that("'de' and 'del' is parsed", {
  expect_equal(fix_date_char("20 de abril de 1994"), as.Date("1994-04-20"))
  expect_equal(fix_date_char("06 de enero del 2008"), as.Date("2008-01-06"))
})

test_that("German format days are supported", {
  expect_equal(fix_date_char("29.08.1992"), as.Date("1992-08-29"))
})

test_that("nunber. + month name (whitespace) + year", {
  expect_equal(fix_date_char("3. Oktober 1990"), as.Date("1990-10-03"))
})

test_that("Month-first dates where the month is given by name", {
  expect_equal(fix_date_char("July 4th, 1776"), as.Date("1776-07-04"))
})

test_that("Non-excel numeric date is parsed correctly", {
  expect_equal(fix_date_char("19374"), as.Date("2023-01-17"))
})

test_that("Excel numeric date is parsed correctly", {
  expect_equal(fix_date_char("41035", excel = TRUE), as.Date("2012-05-06"))
})

test_that("Allow single digit day with double digit year", {
  expect_equal(fix_date_char("03/10/90"), fix_date_char("3/10/90"))
})
