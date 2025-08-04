test_that("unexpected theme raises error raises error", {
  expect_error(
    fix_date_app(theme = "test"),
    "theme should be 'datefixR' or 'none' \n"
  )
})

test_that(".read_data works for xlsx files", {
  upload <- list()
  upload$datapath <- system.file("example.xlsx", package = "datefixR")

  exp.data <- data.frame(
    Apple = c(
      "02-03-21",
      "05 02 19",
      "April 2019",
      "12 1993"
    ),
    Pear = c(
      "Jan 2000",
      "1990",
      "sept 1984",
      "1990-05-01"
    ),
    Lemon = c(
      "1 1 2010",
      "2 Jan 1990",
      "25 Mar 1975",
      "December 2020"
    )
  )
  expect_equal(datefixR:::.read_data(upload), exp.data)
})


test_that(".read_data works for csv files", {
  upload <- list()
  upload$datapath <- system.file("example.xlsx", package = "datefixR")

  exp.data <- data.frame(
    Apple = c(
      "02-03-21",
      "05 02 19",
      "April 2019",
      "12 1993"
    ),
    Pear = c(
      "Jan 2000",
      "1990",
      "sept 1984",
      "1990-05-01"
    ),
    Lemon = c(
      "1 1 2010",
      "2 Jan 1990",
      "25 Mar 1975",
      "December 2020"
    )
  )
  expect_equal(datefixR:::.read_data(upload), exp.data)
})
