test_that("fix_date_char works for a series of malformed dates", {
  bad.date <- "02 03 2021"
  fixed.date <- fix_date_char(bad.date)
  expect_equal(fixed.date, as.Date("2021-03-02"))


  bad.date <- "15/07/11"
  fixed.date <- fix_date_char(bad.date)
  expect_equal(fixed.date, as.Date("2011-07-15"))

  bad.date <- "15/07/84"
  fixed.date <- fix_date_char(bad.date)
  expect_equal(fixed.date, as.Date("1984-07-15"))

  bad.date <- "2015 11 11"
  fixed.date <- fix_date_char(bad.date)
  expect_equal(fixed.date, as.Date("2015-11-11"))

  bad.date <- "05/2015"
  fixed.date <- fix_date_char(bad.date)
  expect_equal(fixed.date, as.Date("2015-05-01"))

  bad.date <- "2020-01"
  fixed.date <- fix_date_char(bad.date)
  expect_equal(fixed.date, as.Date("2020-01-01"))

  bad.date <- "05/89"
  fixed.date <- fix_date_char(bad.date)
  expect_equal(fixed.date, as.Date("1989-05-01"))

  bad.date <- "02/14"
  fixed.date <- fix_date_char(bad.date)
  expect_equal(fixed.date, as.Date("2014-02-01"))

  bad.date <- "1994"
  fixed.date <- fix_date_char(bad.date)
  expect_equal(fixed.date, as.Date("1994-07-01"))
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
