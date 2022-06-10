# fix_dates is deprecated

    Code
      fix_dates(bad.dates, c("some.dates", "some.more.dates"))
    Warning <lifecycle_warning_deprecated>
      `fix_dates()` was deprecated in datefixR 1.0.0.
      Please use `fix_date_df()` instead.
    Output
        id some.dates some.more.dates
      1  1 1992-05-02      2000-05-02
      2  2 2020-04-01      1990-05-01
      3  3 1996-05-01      2012-08-01
      4  4 2020-05-01      2021-04-01
      5  5 1996-04-02      1965-03-01
      6  6 2015-07-01      1984-02-01
      7  7 2009-09-01      2021-09-05

