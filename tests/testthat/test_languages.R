test_that("All January translations work", {
  fixed <- fix_date_char(c(
    "1 january 2000",
    "15 janvier 1975",
    "janv 2020",
    "januar 2015",
    "05 j\u00E4nner 2021",
    "j\u00E4n 2003",
    "enero 2005",
    "jan 2010"
  ))

  expect_equal(fixed, as.Date(c(
    "2000-01-01",
    "1975-01-15",
    "2020-01-01",
    "2015-01-01",
    "2021-01-05",
    "2003-01-01",
    "2005-01-01",
    "2010-01-01"
  )))

  example.df <- data.frame(column = c(
    "1 january 2000",
    "15 janvier 1975",
    "janv 2020",
    "januar 2015",
    "05 j\u00E4nner 2021",
    "j\u00E4n 2003",
    "enero 2005",
    "jan 2010"
  ))
  fixed.df <- fix_date_df(example.df, col.names = "column")

  expect_equal(fixed.df, data.frame(column = as.Date(c(
    "2000-01-01",
    "1975-01-15",
    "2020-01-01",
    "2015-01-01",
    "2021-01-05",
    "2003-01-01",
    "2005-01-01",
    "2010-01-01"
  ))))
})

test_that("All Feburary translations work", {
  fixed <- fix_date_char(c(
    "1 february 2000",
    "15 f\u00E9vrier 1975",
    "fevrier 2020",
    "f\u00E9vr 2015",
    "05 fevr 2021",
    "februar 2003",
    "febrero 2005",
    "feb 2010"
  ))

  expect_equal(fixed, as.Date(c(
    "2000-02-01",
    "1975-02-15",
    "2020-02-01",
    "2015-02-01",
    "2021-02-05",
    "2003-02-01",
    "2005-02-01",
    "2010-02-01"
  )))

  example.df <- data.frame(column = c(
    "1 february 2000",
    "15 f\u00E9vrier 1975",
    "fevrier 2020",
    "f\u00E9vr 2015",
    "05 fevr 2021",
    "februar 2003",
    "febrero 2005",
    "feb 2010"
  ))
  fixed.df <- fix_date_df(example.df, col.names = "column")

  expect_equal(fixed.df, data.frame(column = as.Date(c(
    "2000-02-01",
    "1975-02-15",
    "2020-02-01",
    "2015-02-01",
    "2021-02-05",
    "2003-02-01",
    "2005-02-01",
    "2010-02-01"
  ))))
})

test_that("All March translations work", {
  fixed <- fix_date_char(c(
    "1 march 2000",
    "15 mars 1975",
    "m\u00E4rz 2020",
    "marzo 2015",
    "marz 2021",
    "mar 2003"
  ))

  expect_equal(fixed, as.Date(c(
    "2000-03-01",
    "1975-03-15",
    "2020-03-01",
    "2015-03-01",
    "2021-03-01",
    "2003-03-01"
  )))

  example.df <- data.frame(column = c(
    "1 march 2000",
    "15 mars 1975",
    "m\u00E4rz 2020",
    "marzo 2015",
    "marz 2021",
    "mar 2003"
  ))
  fixed.df <- fix_date_df(example.df, col.names = "column")

  expect_equal(fixed.df, data.frame(column = as.Date(c(
    "2000-03-01",
    "1975-03-15",
    "2020-03-01",
    "2015-03-01",
    "2021-03-01",
    "2003-03-01"
  ))))
})


test_that("All April translations work", {
  fixed <- fix_date_char(c(
    "1 April 2000",
    "15 avril 1975",
    "abril 2020",
    "abr 2015",
    "apr 2021"
  ))

  expect_equal(fixed, as.Date(c(
    "2000-04-01",
    "1975-04-15",
    "2020-04-01",
    "2015-04-01",
    "2021-04-01"
  )))

  example.df <- data.frame(column = c(
    "1 April 2000",
    "15 avril 1975",
    "abril 2020",
    "abr 2015",
    "apr 2021"
  ))
  fixed.df <- fix_date_df(example.df, col.names = "column")

  expect_equal(fixed.df, data.frame(column = as.Date(c(
    "2000-04-01",
    "1975-04-15",
    "2020-04-01",
    "2015-04-01",
    "2021-04-01"
  ))))
})

test_that("All May translations work", {
  fixed <- fix_date_char(c(
    "1 Mayo 2000",
    "15 May 1975",
    "Mai 2020"
  ))

  expect_equal(fixed, as.Date(c(
    "2000-05-01",
    "1975-05-15",
    "2020-05-01"
  )))

  example.df <- data.frame(column = c(
    "1 Mayo 2000",
    "15 May 1975",
    "Mai 2020"
  ))
  fixed.df <- fix_date_df(example.df, col.names = "column")

  expect_equal(fixed.df, data.frame(column = as.Date(c(
    "2000-05-01",
    "1975-05-15",
    "2020-05-01"
  ))))
})


test_that("All June translations work", {
  fixed <- fix_date_char(c(
    "1 June 2000",
    "15 juin 1975",
    "junio 2020",
    "Juni 2015",
    "jun 2021"
  ))

  expect_equal(fixed, as.Date(c(
    "2000-06-01",
    "1975-06-15",
    "2020-06-01",
    "2015-06-01",
    "2021-06-01"
  )))

  example.df <- data.frame(column = c(
    "1 June 2000",
    "15 juin 1975",
    "junio 2020",
    "Juni 2015",
    "jun 2021"
  ))
  fixed.df <- fix_date_df(example.df, col.names = "column")

  expect_equal(fixed.df, data.frame(column = as.Date(c(
    "2000-06-01",
    "1975-06-15",
    "2020-06-01",
    "2015-06-01",
    "2021-06-01"
  ))))
})

test_that("All July translations work", {
  fixed <- fix_date_char(c(
    "1 July 2000",
    "15 juillet 1975",
    "Juil 2020",
    "Julio 2015",
    "juli 2021",
    "jul 2003"
  ))

  expect_equal(fixed, as.Date(c(
    "2000-07-01",
    "1975-07-15",
    "2020-07-01",
    "2015-07-01",
    "2021-07-01",
    "2003-07-01"
  )))

  example.df <- data.frame(column = c(
    "1 July 2000",
    "15 juillet 1975",
    "Juil 2020",
    "Julio 2015",
    "juli 2021",
    "jul 2003"
  ))
  fixed.df <- fix_date_df(example.df, col.names = "column")

  expect_equal(fixed.df, data.frame(column = as.Date(c(
    "2000-07-01",
    "1975-07-15",
    "2020-07-01",
    "2015-07-01",
    "2021-07-01",
    "2003-07-01"
  ))))
})


test_that("All August translations work", {
  fixed <- fix_date_char(c(
    "1 August 2000",
    "15 aug 1975",
    "ao\u00FBt 2020",
    "aout 2015",
    "agosto 2021"
  ))

  expect_equal(fixed, as.Date(c(
    "2000-08-01",
    "1975-08-15",
    "2020-08-01",
    "2015-08-01",
    "2021-08-01"
  )))

  example.df <- data.frame(column = c(
    "1 August 2000",
    "15 aug 1975",
    "ao\u00FBt 2020",
    "aout 2015",
    "agosto 2021"
  ))
  fixed.df <- fix_date_df(example.df, col.names = "column")

  expect_equal(fixed.df, data.frame(column = as.Date(c(
    "2000-08-01",
    "1975-08-15",
    "2020-08-01",
    "2015-08-01",
    "2021-08-01"
  ))))
})


test_that("All September translations work", {
  fixed <- fix_date_char(c(
    "1 september 2000",
    "15 septembre 1975",
    "septiembre 2020",
    "set 2015",
    "Sept 2021",
    "Sep 2003"
  ))

  expect_equal(fixed, as.Date(c(
    "2000-09-01",
    "1975-09-15",
    "2020-09-01",
    "2015-09-01",
    "2021-09-01",
    "2003-09-01"
  )))

  example.df <- data.frame(column = c(
    "1 september 2000",
    "15 septembre 1975",
    "septiembre 2020",
    "set 2015",
    "Sept 2021",
    "Sep 2003"
  ))
  fixed.df <- fix_date_df(example.df, col.names = "column")

  expect_equal(fixed.df, data.frame(column = as.Date(c(
    "2000-09-01",
    "1975-09-15",
    "2020-09-01",
    "2015-09-01",
    "2021-09-01",
    "2003-09-01"
  ))))
})



test_that("All October translations work", {
  fixed <- fix_date_char(c(
    "1 october 2000",
    "15 Octobre 1975",
    "oktober 2020",
    "Okt 2015",
    "octubre 2021",
    "Oct 2003"
  ))

  expect_equal(fixed, as.Date(c(
    "2000-10-01",
    "1975-10-15",
    "2020-10-01",
    "2015-10-01",
    "2021-10-01",
    "2003-10-01"
  )))

  example.df <- data.frame(column = c(
    "1 october 2000",
    "15 Octobre 1975",
    "oktober 2020",
    "Okt 2015",
    "octubre 2021",
    "Oct 2003"
  ))
  fixed.df <- fix_date_df(example.df, col.names = "column")

  expect_equal(fixed.df, data.frame(column = as.Date(c(
    "2000-10-01",
    "1975-10-15",
    "2020-10-01",
    "2015-10-01",
    "2021-10-01",
    "2003-10-01"
  ))))
})


test_that("All November translations work", {
  fixed <- fix_date_char(c(
    "1 november 2000",
    "15 Novembre 1975",
    "noviembre 2020",
    "Nov 2015"
  ))

  expect_equal(fixed, as.Date(c(
    "2000-11-01",
    "1975-11-15",
    "2020-11-01",
    "2015-11-01"
  )))

  example.df <- data.frame(column = c(
    "1 november 2000",
    "15 Novembre 1975",
    "noviembre 2020",
    "Nov 2015"
  ))
  fixed.df <- fix_date_df(example.df, col.names = "column")

  expect_equal(fixed.df, data.frame(column = as.Date(c(
    "2000-11-01",
    "1975-11-15",
    "2020-11-01",
    "2015-11-01"
  ))))
})

test_that("All December translations work", {
  fixed <- fix_date_char(c(
    "1 December 2000",
    "15 d\u00E9cembre 1975",
    "decembre 2020",
    "d\u00E9c 2015",
    "05 dezember 2021",
    "Dez 2003",
    "diciembre 2005",
    "dic 2010",
    "03-dec-2000"
  ))

  expect_equal(fixed, as.Date(c(
    "2000-12-01",
    "1975-12-15",
    "2020-12-01",
    "2015-12-01",
    "2021-12-05",
    "2003-12-01",
    "2005-12-01",
    "2010-12-01",
    "2000-12-03"
  )))

  example.df <- data.frame(column = c(
    "1 December 2000",
    "15 d\u00E9cembre 1975",
    "decembre 2020",
    "d\u00E9c 2015",
    "05 dezember 2021",
    "Dez 2003",
    "diciembre 2005",
    "dic 2010",
    "03-dec-2000"
  ))
  fixed.df <- fix_date_df(example.df, col.names = "column")

  expect_equal(fixed.df, data.frame(column = as.Date(c(
    "2000-12-01",
    "1975-12-15",
    "2020-12-01",
    "2015-12-01",
    "2021-12-05",
    "2003-12-01",
    "2005-12-01",
    "2010-12-01",
    "2000-12-03"
  ))))
})
