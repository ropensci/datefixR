if (l10n_info()$MBCS) {
  # Tests will fail if multibyte characters are not supported.

  test_that("All January translations work", {
    dates <-
      c(
        "1 january 2000" = "2000-01-01",
        "le 1er janvier 1975" = "1975-01-01",
        "janv 2020" = "2020-01-01",
        "januar 2015" = "2015-01-01",
        "1. Januar 2035" = "2035-01-01",
        "05. J\u00E4nner 2021" = "2021-01-05",
        "J\u00E4n 2003" = "2003-01-01",
        "enero 2005" = "2005-01-01",
        "ener 2010" = "2010-01-01",
        "ene 2000" = "2000-01-01",
        "Jan 2010" = "2010-01-01",
        "10 de janeiro de 2019" = "2019-01-10",
        "18 \u044f\u043d\u0432\u0430\u0440\u044c 2023" = "2023-01-18",
        "18 \u044f\u043d\u0432\u0430\u0440\u044f 2023" = "2023-01-18",
        "18 \u044f\u043d\u0432 2023" = "2023-01-18",
        "\u044f\u043d\u0432 2023" = "2023-01-01"
      )

    fixed <- fix_date_char(names(dates))

    expect_equal(fixed, as.Date(unname(dates)))

    example.df <- data.frame(column = names(dates))
    fixed.df <- fix_date_df(example.df, col.names = "column")

    expect_equal(fixed.df, data.frame(column = as.Date(unname(dates))))
  })

  test_that("All Feburary translations work", {
    dates <-
      c(
        "1 february 2000" = "2000-02-01",
        "15 f\u00E9vrier 1975" = "1975-02-15",
        "fevrier 2020" = "2020-02-01",
        "f\u00E9vr 2015" = "2015-02-01",
        "05 fevr 2021" = "2021-02-05",
        "29. Februar 2024" = "2024-02-29",
        "Feb 2010" = "2010-02-01",
        "febrero 2005" = "2005-02-01",
        "25 de fevereiro de 2018" = "2018-02-25",
        "18 \u0444\u0435\u0432\u0440\u0430\u043b\u044c 2023" = "2023-02-18",
        "18 \u0444\u0435\u0432\u0440\u0430\u043b\u044f 2023" = "2023-02-18",
        "18 \u0444\u0435\u0432 2023" = "2023-02-18",
        "\u0444\u0435\u0432 2023" = "2023-02-01"
      )

    fixed <- fix_date_char(names(dates))

    expect_equal(fixed, as.Date(unname(dates)))

    example.df <- data.frame(column = names(dates))
    fixed.df <- fix_date_df(example.df, col.names = "column")

    expect_equal(fixed.df, data.frame(column = as.Date(unname(dates))))
  })

  test_that("All March translations work", {
    dates <-
      c(
        "1 march 2000" = "2000-03-01",
        "15 mars 1975" = "1975-03-15",
        "M\u00E4rz 2020" = "2020-03-01",
        "14. M\u00E4rz 1879" = "1879-03-14",
        "marzo 2015" = "2015-03-01",
        "marz 2021" = "2021-03-01",
        "mar 2003" = "2003-03-01",
        "mar\u00E7o 1980" = "1980-03-01",
        "marco 2000" = "2000-03-01",
        "18 \u043C\u0430\u0440\u0442 2023" = "2023-03-18",
        "18 \u043C\u0430\u0440\u0442\u0430 2023" = "2023-03-18",
        "18 \u043C\u0430\u0440 2023" = "2023-03-18",
        "\u043C\u0430\u0440 2023" = "2023-03-01"
      )

    fixed <- fix_date_char(names(dates))

    expect_equal(fixed, as.Date(unname(dates)))

    example.df <- data.frame(column = names(dates))
    fixed.df <- fix_date_df(example.df, col.names = "column")

    expect_equal(fixed.df, data.frame(column = as.Date(unname(dates))))
  })

  test_that("All April translations work", {
    dates <-
      c(
        "1. April 2000" = "2000-04-01",
        "Le 15 avril 1975" = "1975-04-15",
        "abril 2020" = "2020-04-01",
        "abr 2015" = "2015-04-01",
        "apr 2021" = "2021-04-01",
        "18 \u0430\u043f\u0440\u0435\u043b\u044c 2023" = "2023-04-18",
        "18 \u0430\u043f\u0440\u0435\u043b\u044f 2023" = "2023-04-18",
        "18 \u0430\u043f\u0440 2023" = "2023-04-18",
        "\u0430\u043f\u0440 2023" = "2023-04-01"
      )

    fixed <- fix_date_char(names(dates))

    expect_equal(fixed, as.Date(unname(dates)))

    example.df <- data.frame(column = names(dates))
    fixed.df <- fix_date_df(example.df, col.names = "column")

    expect_equal(fixed.df, data.frame(column = as.Date(unname(dates))))
  })

  test_that("All May translations work", {
    dates <-
      c(
        "1 Mayo 2000" = "2000-05-01",
        "15 May 1975" = "1975-05-15",
        "23. Mai 2020" = "2020-05-23",
        "Mai 2020" = "2020-05-01",
        "15 de maio de 1993" = "1993-05-15",
        "18 \u043c\u0430\u0439 2023" = "2023-05-18",
        "18 \u043c\u0430\u044f 2023" = "2023-05-18",
        "\u043c\u0430\u0439 2023" = "2023-05-01"
      )

    fixed <- fix_date_char(names(dates))

    expect_equal(fixed, as.Date(unname(dates)))

    example.df <- data.frame(column = names(dates))
    fixed.df <- fix_date_df(example.df, col.names = "column")

    expect_equal(fixed.df, data.frame(column = as.Date(unname(dates))))
  })

  test_that("All June translations work", {
    dates <-
      c(
        "1 June 2000" = "2000-06-01",
        "15 juin 1975" = "1975-06-15",
        "junio 2020" = "2020-06-01",
        "12. Juni 2050" = "2050-06-12",
        "Juni 2015" = "2015-06-01",
        "jun 2021" = "2021-06-01",
        "12 de junho de 2015" = "2015-06-12",
        "18 \u0438\u044e\u043d\u044c 2023" = "2023-06-18",
        "18 \u0438\u044e\u043d\u044f 2023" = "2023-06-18",
        "18 \u0438\u044e\u043d 2023" = "2023-06-18",
        "\u0438\u044e\u043d 2023" = "2023-06-01"
      )

    fixed <- fix_date_char(names(dates))

    expect_equal(fixed, as.Date(unname(dates)))

    example.df <- data.frame(column = names(dates))
    fixed.df <- fix_date_df(example.df, col.names = "column")

    expect_equal(fixed.df, data.frame(column = as.Date(unname(dates))))
  })

  test_that("All July translations work", {
    dates <-
      c(
        "1 July 2000" = "2000-07-01",
        "15 juillet 1975" = "1975-07-15",
        "Juil 2020" = "2020-07-01",
        "Julio 2015" = "2015-07-01",
        "Juli 2021" = "2021-07-01",
        "jul 2003" = "2003-07-01",
        "julho de 1997" = "1997-07-01",
        "18 \u0438\u044e\u043b\u044c 2023" = "2023-07-18",
        "18 \u0438\u044e\u043b\u044f 2023" = "2023-07-18",
        "18 \u0438\u044e\u043b 2023" = "2023-07-18",
        "\u0438\u044e\u043b 2023" = "2023-07-01"
      )

    fixed <- fix_date_char(names(dates))

    expect_equal(fixed, as.Date(unname(dates)))

    example.df <- data.frame(column = names(dates))
    fixed.df <- fix_date_df(example.df, col.names = "column")

    expect_equal(fixed.df, data.frame(column = as.Date(unname(dates))))
  })

  test_that("All August translations work", {
    dates <-
      c(
        "1 August 2000" = "2000-08-01",
        "15 aug 1975" = "1975-08-15",
        "ao\u00FBt 2020" = "2020-08-01",
        "aout 2015" = "2015-08-01",
        "agosto 2021" = "2021-08-01",
        "18 \u0430\u0432\u0433\u0443\u0441\u0442 2023" = "2023-08-18",
        "18 \u0430\u0432\u0433\u0443\u0441\u0442\u0430 2023" = "2023-08-18",
        "18 \u0430\u0432\u0433 2023" = "2023-08-18",
        "\u0430\u0432\u0433 2023" = "2023-08-01"
      )

    fixed <- fix_date_char(names(dates))

    expect_equal(fixed, as.Date(unname(dates)))

    example.df <- data.frame(column = names(dates))
    fixed.df <- fix_date_df(example.df, col.names = "column")

    expect_equal(fixed.df, data.frame(column = as.Date(unname(dates))))
  })

  test_that("All September translations work", {
    dates <-
      c(
        "1 september 2000" = "2000-09-01",
        "15 septembre 1975" = "1975-09-15",
        "septiembre 2020" = "2020-09-01",
        "set 2015" = "2015-09-01",
        "Sept 2021" = "2021-09-01",
        "Sep 2003" = "2003-09-01",
        "20 de setembro de 1975" = "1975-09-20",
        "18 \u0441\u0435\u043d\u0442\u044f\u0431\u0440\u044c 2023" = "2023-09-18",
        "18 \u0441\u0435\u043d\u0442\u044f\u0431\u0440\u044f 2023" = "2023-09-18",
        "18 \u0441\u0435\u043d\u0442 2023" = "2023-09-18",
        "\u0441\u0435\u043d\u0442 2023" = "2023-09-01"
      )

    fixed <- fix_date_char(names(dates))

    expect_equal(fixed, as.Date(unname(dates)))

    example.df <- data.frame(column = names(dates))
    fixed.df <- fix_date_df(example.df, col.names = "column")

    expect_equal(fixed.df, data.frame(column = as.Date(unname(dates))))
  })

  test_that("All October translations work", {
    dates <-
      c(
        "1 october 2000" = "2000-10-01",
        "15 Octobre 1975" = "1975-10-15",
        "Oktober 2020" = "2020-10-01",
        "Okt 2015" = "2015-10-01",
        "octubre 2021" = "2021-10-01",
        "Oct 2003" = "2003-10-01",
        "27 de outubro de 1987" = "1987-10-27",
        "18 \u043e\u043a\u0442\u044f\u0431\u0440\u044c 2023" = "2023-10-18",
        "18 \u043e\u043a\u0442\u044f\u0431\u0440\u044f 2023" = "2023-10-18",
        "18 \u043e\u043a\u0442 2023" = "2023-10-18",
        "\u043e\u043a\u0442 2023" = "2023-10-01"
      )

    fixed <- fix_date_char(names(dates))

    expect_equal(fixed, as.Date(unname(dates)))

    example.df <- data.frame(column = names(dates))
    fixed.df <- fix_date_df(example.df, col.names = "column")

    expect_equal(fixed.df, data.frame(column = as.Date(unname(dates))))
  })

  test_that("All November translations work", {
    dates <-
      c(
        "1 november 2000" = "2000-11-01",
        "15 Novembre 1975" = "1975-11-15",
        "noviembre 2020" = "2020-11-01",
        "9. Nov. 1989" = "1989-11-09",
        "Nov 2015" = "2015-11-01",
        "5 de novembro de 1990" = "1990-11-05",
        "18 \u043d\u043e\u044f\u0431\u0440\u044c 2023" = "2023-11-18",
        "18 \u043d\u043e\u044f\u0431\u0440\u044f 2023" = "2023-11-18",
        "18 \u043d\u043e\u044f 2023" = "2023-11-18",
        "\u043d\u043e\u044f 2023" = "2023-11-01"
      )

    fixed <- fix_date_char(names(dates))

    expect_equal(fixed, as.Date(unname(dates)))

    example.df <- data.frame(column = names(dates))
    fixed.df <- fix_date_df(example.df, col.names = "column")

    expect_equal(fixed.df, data.frame(column = as.Date(unname(dates))))
  })

  test_that("All December translations work", {
    dates <-
      c(
        "1 December 2000" = "2000-12-01",
        "15 d\u00E9cembre 1975" = "1975-12-15",
        "decembre 2020" = "2020-12-01",
        "d\u00E9c 2015" = "2015-12-01",
        "24. Dezember 2021" = "2021-12-24",
        "Dez 2003" = "2003-12-01",
        "diciembre 2005" = "2005-12-01",
        "dic 2010" = "2010-12-01",
        "03-dec-2000" = "2000-12-03",
        "16 de dezembro de 2020" = "2020-12-16",
        "18 \u0434\u0435\u043a\u0430\u0431\u0440\u044c 2023" = "2023-12-18",
        "18 \u0434\u0435\u043a\u0430\u0431\u0440\u044f 2023" = "2023-12-18",
        "18 \u0434\u0435\u043a 2023" = "2023-12-18",
        "\u0434\u0435\u043a 2023" = "2023-12-01"
      )

    fixed <- fix_date_char(names(dates))

    expect_equal(fixed, as.Date(unname(dates)))

    example.df <- data.frame(column = names(dates))
    fixed.df <- fix_date_df(example.df, col.names = "column")

    expect_equal(fixed.df, data.frame(column = as.Date(unname(dates))))
  })
}
