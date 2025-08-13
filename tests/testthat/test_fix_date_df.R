test_that("fix_date_df works for a series of malformed dates", {
  bad.dates <- data.frame(
    id = seq(7),
    some.dates = c(
      "02/05/92",
      "01-04-2020",
      "1996/05/01",
      "2020-05-01",
      "02-04-96",
      "2015",
      "Sept 2009"
    ),
    some.more.dates = c(
      "02/05/00",
      "05/1990",
      "2012-08",
      "apr-21",
      "mar-65",
      "feb 84",
      "5 sept 2021"
    )
  )

  fixed.df <- fix_date_df(bad.dates, c("some.dates", "some.more.dates"))

  expected.df <- data.frame(
    id = seq(7),
    some.dates = c(
      "1992-05-02",
      "2020-04-01",
      "1996-05-01",
      "2020-05-01",
      "1996-04-02",
      "2015-07-01",
      "2009-09-01"
    ),
    some.more.dates = c(
      "2000-05-02",
      "1990-05-01",
      "2012-08-01",
      "2021-04-01",
      "1965-03-01",
      "1984-02-01",
      "2021-09-05"
    )
  )
  expected.df$some.dates <- as.Date(expected.df$some.dates)
  expected.df$some.more.dates <- as.Date(expected.df$some.more.dates)
  expect_equal(fixed.df, expected.df)
})

test_that("returns error for dates that are malformed beyond auto fix", {
  bad.dates <- data.frame(
    id = seq(9),
    some.dates = c(
      "02/05/92",
      "01-04-2020",
      "1996/05/01",
      "2020-05-01",
      "02-04-96",
      "2015",
      "02/05/00",
      "05/1990",
      "20125/02"
    )
  )
  expect_error(fix_date_df(bad.dates, "some.dates"), "unable to tidy a date")
})

test_that("Handle empty dates correctly", {
  really.bad.dataframe <- data.frame(
    id = seq(2),
    some.dates = c(NA, "")
  )
  fixed.df <- fix_date_df(really.bad.dataframe, "some.dates")

  expected.df <- data.frame(
    id = seq(2),
    some.dates = c(NA, NA)
  )
  expected.df$some.dates <- as.Date(expected.df$some.dates)

  expect_equal(fixed.df, expected.df)
})

test_that("error if unexpected data type", {
  exvector <- c(1, 2, 3)
  expect_error(
    fix_date_df(exvector, "some.dates"),
    "df should be a dataframe object!"
  )

  expect_error(
    fix_date_df(data.frame(), 3),
    "col.names should be a character vector!"
  )
})

test_that("error if day.impute or month.impute are wrong format", {
  exvector <- c(1, 2, 3)
  expect_error(
    fix_date_df(exvector, "some.dates"),
    "df should be a dataframe object!"
  )

  expect_error(
    fix_date_df(data.frame(), 3),
    "col.names should be a character vector!"
  )
  bad.dates <- data.frame(
    id = seq(6),
    some.dates = c(
      "02/05/92",
      "01-04-2020",
      "1996/05/01",
      "2020-05-01",
      "02-04-96",
      "2015"
    ),
    some.more.dates = c(
      "02/05/00",
      "05/1990",
      "2012-08",
      "apr-21",
      "mar-65",
      "feb 84"
    )
  )

  expect_error(
    fix_date_df(bad.dates, c("some.dates", "some.more.dates"), day.impute = 35),
    "day.impute should be an integer between 1 and 31\n"
  )
  expect_error(
    fix_date_df(
      bad.dates,
      c("some.dates", "some.more.dates"),
      day.impute = 2.2
    ),
    "day.impute should be an integer\n"
  )
  expect_error(
    fix_date_df(
      bad.dates,
      c("some.dates", "some.more.dates"),
      month.impute = 13
    ),
    "month.impute should be an integer between 1 and 12\n"
  )
  expect_error(
    fix_date_df(
      bad.dates,
      c("some.dates", "some.more.dates"),
      month.impute = 2.2
    ),
    "month.impute should be an integer\n"
  )
  expect_error(
    fix_date_df(
      bad.dates,
      c("some.dates", "some.more.dates"),
      month.impute = "apr"
    ),
    "month.impute should be an integer between 1 and 12\n"
  )
})

test_that("error if day.impute or month.impute are in wrong format", {
  temp <- data.frame(example = "1994")

  expect_equal(
    fix_date_df(temp, "example", month.impute = 11),
    data.frame(example = as.Date("1994-11-01"))
  )
})

test_that("Error if month out of bounds", {
  temp <- data.frame(id = 1, date = "13-1994")

  expect_error(
    fix_date_df(temp, "date"),
    "Month not in expected range"
  )
})


test_that("Imputing day with NA results in NA", {
  temp <- data.frame(id = 1, date = "04-1994")
  expect_warning(
    date.guess <- fix_date_df(temp, "date", day.impute = NA),
    "NA imputed for subject 1 \\(date: 04\\-1994\\)"
  )
  expect_equal(date.guess, data.frame(id = 1, date = as.Date(NA)))
})


test_that("Imputing month with NA results in NA", {
  temp <- data.frame(id = 1, date = "1994")
  expect_warning(
    date.guess <- fix_date_df(temp, "date", month.impute = NA),
    "NA imputed for subject 1 \\(date: 1994\\)"
  )
  expect_equal(
    date.guess,
    data.frame(id = 1, date = as.Date(NA))
  )
})


test_that("Error if imputing month with NULL", {
  temp <- data.frame(id = 1, date = "1994")
  expect_error(
    fix_date_df(temp, "date", month.impute = NULL),
    "Missing month with no imputation value given \n"
  )
})

test_that("Error if imputing day with NULL", {
  temp <- data.frame(id = 1, date = "07-1994")
  expect_error(
    fix_date_df(temp, "date", day.impute = NULL),
    "Missing day with no imputation value given \n"
  )
})


test_that("fix_date_df works for a mdy format", {
  bad.dates <- data.frame(
    id = seq(6),
    some.dates = c(
      "05/02/92",
      "04-01-2020",
      "1996/05/01",
      "2020-01-05",
      "04-02-96",
      "2015"
    ),
    some.more.dates = c(
      "05/02/00",
      "05/1990",
      "2012-08",
      "apr-21",
      "mar-65",
      "feb 84"
    )
  )

  fixed.df <- fix_date_df(
    bad.dates,
    c("some.dates", "some.more.dates"),
    format = "mdy"
  )

  expected.df <- data.frame(
    id = seq(6),
    some.dates = c(
      "1992-05-02",
      "2020-04-01",
      "1996-05-01",
      "2020-01-05",
      "1996-04-02",
      "2015-07-01"
    ),
    some.more.dates = c(
      "2000-05-02",
      "1990-05-01",
      "2012-08-01",
      "2021-04-01",
      "1965-03-01",
      "1984-02-01"
    )
  )
  expected.df$some.dates <- as.Date(expected.df$some.dates)
  expected.df$some.more.dates <- as.Date(expected.df$some.more.dates)
  expect_equal(fixed.df, expected.df)
})


test_that("Non-excel nuneric date is parsed correctly", {
  bad.date <- data.frame(id = 1, some.date = "19374")
  fixed.df <- fix_date_df(bad.date, "some.date")
  expected.df <- data.frame(id = 1, some.date = "2023-01-17")
  expected.df$some.date <- as.Date(expected.df$some.date)
  expect_equal(fixed.df, expected.df)
})

test_that("Excel numeric date is parsed correctly", {
  bad.date <- data.frame(id = 1, some.date = "41035")
  fixed.df <- fix_date_df(bad.date, "some.date", excel = TRUE)
  expected.df <- data.frame(id = 1, some.date = "2012-05-06")
  expected.df$some.date <- as.Date(expected.df$some.date)
  expect_equal(fixed.df, expected.df)
})

test_that("checkday errors when input is out of range", {
  result <- try(datefixR:::checkday(45), silent = TRUE)
  expect_s3_class(result, "extendr_error")
  # Note: The actual error message is wrapped in try-error and not directly accessible

  # Test that valid values work
  expect_no_condition(datefixR:::checkday(15)) # Should return without error for valid day
  expect_no_condition(datefixR:::checkday(1)) # Should return without error for valid day
  expect_no_condition(datefixR:::checkday(31)) # Should return without error for valid day

  # Test other invalid values also throw errors
  expect_s3_class(try(datefixR:::checkday(0), silent = TRUE), "extendr_error")
  expect_s3_class(try(datefixR:::checkday(32), silent = TRUE), "extendr_error")
})


test_that("Roman numerical dates handled correctly", {
  bad.dataframe <- data.frame(
    id = seq(2),
    some.dates = c("20-iv-2023", "2010/v/19")
  )
  fixed.df <- fix_date_df(bad.dataframe, "some.dates", roman.numeral = TRUE)

  expected.df <- data.frame(
    id = seq(2),
    some.dates = c("2023-04-20", "2010-05-19")
  )
  expected.df$some.dates <- as.Date(expected.df$some.dates)

  expect_equal(fixed.df, expected.df)
})

test_that("parallel processing with multiple date columns works correctly", {
  # Skip if future packages are not available
  skip_if_not_installed("future")
  skip_if_not_installed("future.apply")

  # Create test dataframe with two date columns
  test_df <- data.frame(
    id = 1:4,
    dates_col1 = c("01/01/2020", "02/02/2021", "03/03/2022", "15-12-2019"),
    dates_col2 = c("04/04/2020", "05/05/2021", "06/06/2022", "dec 2018")
  )

  # Process with parallel processing (2 cores)
  result_parallel <- fix_date_df(test_df, c("dates_col1", "dates_col2"), cores = 2)

  # Process sequentially for comparison
  result_sequential <- fix_date_df(test_df, c("dates_col1", "dates_col2"), cores = 1)

  # Results should be identical regardless of processing method
  expect_equal(result_parallel, result_sequential)

  # Verify the actual parsed dates are correct
  expected_df <- data.frame(
    id = 1:4,
    dates_col1 = as.Date(c("2020-01-01", "2021-02-02", "2022-03-03", "2019-12-15")),
    dates_col2 = as.Date(c("2020-04-04", "2021-05-05", "2022-06-06", "2018-12-01"))
  )

  expect_equal(result_parallel, expected_df)
})

test_that("parallel processing falls back to sequential for single column", {
  # Create test dataframe with one date column
  test_df <- data.frame(
    id = 1:3,
    single_date_col = c("01/01/2020", "02/02/2021", "03/03/2022")
  )

  # Process with cores = 4 (should fall back to sequential since only 1 column)
  result <- fix_date_df(test_df, "single_date_col", cores = 4)

  # Verify the result is correct
  expected_df <- data.frame(
    id = 1:3,
    single_date_col = as.Date(c("2020-01-01", "2021-02-02", "2022-03-03"))
  )

  expect_equal(result, expected_df)
})

test_that("NA values in dataframe columns are preserved correctly", {
  # Test dataframe with mixed NA, empty string, and "NA" string
  test_df <- data.frame(
    id = 1:5,
    dates = c("2023-01-01", NA, "2024-01-01", "", "NA")
  )

  result_df <- fix_date_df(test_df, "dates")

  # Check that valid dates are parsed correctly
  expect_equal(result_df$dates[1], as.Date("2023-01-01"))
  expect_equal(result_df$dates[3], as.Date("2024-01-01"))

  # Check that all types of NA are preserved as NA
  expect_true(is.na(result_df$dates[2])) # NA
  expect_true(is.na(result_df$dates[4])) # empty string
  expect_true(is.na(result_df$dates[5])) # "NA" string

  # Ensure we didn't get the placeholder date (1999-01-01)
  expect_false(any(result_df$dates == as.Date("1999-01-01"), na.rm = TRUE))
})

test_that("Dataframe with all NA values returns all NA", {
  test_df <- data.frame(
    id = 1:3,
    dates = c(NA, "", "NA")
  )

  result_df <- fix_date_df(test_df, "dates")

  # All should be NA
  expect_true(all(is.na(result_df$dates)))
  expect_equal(length(result_df$dates), 3)

  # Ensure we didn't get the placeholder date
  expect_false(any(result_df$dates == as.Date("1999-01-01"), na.rm = TRUE))
})
