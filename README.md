
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datefixR <img src="man/figures/logo.png" align="right" width="150"/>

<!-- badges: start -->

| Usage                                                                                                                                                                    | Release                                                                                                                                          | Development                                                                                                                                                                                            | Translation Status                                                                                                                  |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| ![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)                                                                            | [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/datefixR)](https://cran.r-project.org/package=datefixR)                             | ![Rust language](https://img.shields.io/badge/Rust-D34516?style=for-the-badge&logo=rust&logoColor=#E57324)                                                                                             | [![German localization](https://gitlocalize.com/repo/8364/de/badge.svg)](https://gitlocalize.com/repo/8364/de?utm_source=badge)     |
| [![License: GPL-3](https://img.shields.io/badge/License-GPL3-green.svg)](https://opensource.org/license/gpl-3-0)                                                         | [![datefixR status badge](https://ropensci.r-universe.dev/badges/datefixR)](https://ropensci.r-universe.dev/datefixR)                            | [![R build status](https://github.com/ropensci/datefixR/workflows/CI/badge.svg)](https://github.com/ropensci/datefixR/actions)                                                                         | [![Spanish localization](https://gitlocalize.com/repo/8364/es/badge.svg)](https://gitlocalize.com/repo/8364/es?utm_source=badge)    |
| [![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/grand-total/datefixR?color=blue)](https://r-pkg.org/pkg/datefixR)                                    | [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5655311.svg)](https://doi.org/10.5281/zenodo.5655311)                                        | [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) | [![French localization](https://gitlocalize.com/repo/8364/fr/badge.svg)](https://gitlocalize.com/repo/8364/fr?utm_source=badge)     |
| ![website status](https://img.shields.io/website?down_color=red&down_message=offline&up_color=green&up_message=online&url=https%3A%2F%2Fdocs.ropensci.org%2FdatefixR%2F) | [![Status at rOpenSci Software Peer Review](https://badges.ropensci.org/533_status.svg)](https://github.com/ropensci/software-review/issues/533) | [![codecov](https://codecov.io/gh/ropensci/datefixR/branch/main/graph/badge.svg?token=zycOVwlq1m)](https://app.codecov.io/gh/ropensci/datefixR)                                                        | [![Indonesian localization](https://gitlocalize.com/repo/8364/id/badge.svg)](https://gitlocalize.com/repo/8364/id?utm_source=badge) |
|                                                                                                                                                                          |                                                                                                                                                  | [![Tidyverse style guide](https://img.shields.io/static/v1?label=Code%20Style&message=Tidyverse&color=1f1c30)](https://style.tidyverse.org)                                                            | [![Russian localization](https://gitlocalize.com/repo/8364/ru/badge.svg)](https://gitlocalize.com/repo/8364/ru?utm_source=badge)    |

<!-- badges: end -->

**`datefixR` is an R package that automatically standardizes messy date
data into consistent, machine-readable formats.** Whether you’re dealing
with free-text web form entries like “02 05 92”, “2020-may-01”, or “le 3
mars 2013”, `datefixR` intelligently parses diverse date formats and
converts them to R’s standard Date class. Under the hood, `datefixR`
uses Rust for fast and memory-safe parsing.

**Key features:**

  - **Smart parsing**: Handles mixed date formats, separators, and
    representations in a single dataset.
  - **Multilingual support**: Recognizes dates in English, French,
    German, Spanish, Indonesian, and Russian.
  - **Missing data imputation**: User-controlled behavior for incomplete
    dates (missing days/months).
  - **Error reporting**: If a date cannot be parsed, the user is
    informed of the provided date and associated row ID, allowing for
    easier debugging and correction.
  - **Excel compatibility**: Supports both R and Excel numeric date
    representations.
  - **Shiny integration**: Interactive web app for data exploration and
    cleaning. <br>

<img src="man/figures/example.svg" width="800"/>

## Quick Start

Here’s a simple example showing how `datefixR` cleans messy date data:

``` r
library(datefixR)

# Create some messy date data
messy_dates <- c("02/05/92", "2020-may-01", "le 3 mars 2013", "1996")
messy_df <- data.frame(id = 1:4, dates = messy_dates)
print(messy_df)
#>   id          dates
#> 1  1       02/05/92
#> 2  2    2020-may-01
#> 3  3 le 3 mars 2013
#> 4  4           1996

# Clean the dates
clean_dates <- fix_date_char(messy_dates) # Clean a character vector
clean_df <- fix_date_df(messy_df, "dates") # Clean a column of a dataframe
print(clean_df)
#>   id      dates
#> 1  1 1992-05-02
#> 2  2 2020-05-01
#> 3  3 2013-03-03
#> 4  4 1996-07-01
```

The package automatically standardizes dates in different formats (named
months, various separators, incomplete dates) into R’s standard
`yyyy-mm-dd` format. When dates are partially missing (like the day or
month), they can be imputed. Whilst imputation defaults to July 1st for
incomplete dates, this behaviour can be changed including the prevention
of any imputation.

## Installation

### Stable Release (Recommended)

`datefixR` is available on CRAN:

``` r
install.packages("datefixR")
```

### Latest Stable (r-universe)

For the most up-to-date stable version via
[r-universe](https://r-universe.dev/search):

``` r
# Enable universe(s) by ropensci
options(repos = c(
  ropensci = "https://ropensci.r-universe.dev",
  CRAN = "https://cloud.r-project.org"
))

install.packages("datefixR")
```

## Getting Started

## Package vignette

`datefixR` has a “Getting Started” vignette which describes how to use
this package in more detail than this page. View the vignette by either
calling

``` r
browseVignettes("datefixR")
```

or visiting the vignette on the [package
website](https://docs.ropensci.org/datefixR/articles/datefixR.html)

Additional vignettes are available describing `datefixR`’s localization
features and how to use the Shiny app.

## Usage

`datefixR` provides flexible date standardization capabilities across
different data structures and formats. This section demonstrates various
use cases with practical examples.

### Character Vector Cleaning

The most basic use case involves cleaning a character vector of messy
dates using `fix_date_char()`:

``` r
library(datefixR)

# Mixed format dates
messy_dates <- c(
  "02/05/92", # US format, 2-digit year
  "2020-may-01", # ISO with named month
  "le 3 mars 2013", # French format
  "1996", # Year only
  "22.07.1977", # European format
  "jan 2020" # Month-year only
)

# Clean all dates at once
clean_dates <- fix_date_char(messy_dates)
print(clean_dates)
#> [1] "1992-05-02" "2020-05-01" "2013-03-03" "1996-07-01" "1977-07-22"
#> [6] "2020-01-01"
```

This function automatically handles various separators (“-”, “/”, “.”,
spaces), different date orders, named months in multiple languages, and
incomplete dates.

### Data Frame Cleaning

For structured data, use `fix_date_df()` to clean multiple date columns
simultaneously:

``` r
# Load example dataset
data("exampledates")
knitr::kable(exampledates)
```

| id | some.dates              | some.more.dates |
| :- | :---------------------- | :-------------- |
| 1  | 02 05 92                | 2015            |
| 2  | 01-04-2020              | 02/05/00        |
| 3  | 1996/05/01              | 05/1990         |
| 4  | 2020-may-01             | 2012-08         |
| 5  | 02-04-96                | jan 2020        |
| 6  | le 3 mars 2013          | 22.07.1977      |
| 7  | 7 de septiembre de 2014 | 13821           |

``` r

# Fix multiple columns
fixed_df <- fix_date_df(exampledates, c("some.dates", "some.more.dates"))
knitr::kable(fixed_df)
```

| id | some.dates | some.more.dates |
| :- | :--------- | :-------------- |
| 1  | 1992-05-02 | 2015-07-01      |
| 2  | 2020-04-01 | 2000-05-02      |
| 3  | 1996-05-01 | 1990-05-01      |
| 4  | 2020-05-01 | 2012-08-01      |
| 5  | 1996-04-02 | 2020-01-01      |
| 6  | 2013-03-03 | 1977-07-22      |
| 7  | 2014-09-07 | 2007-11-04      |

The function preserves non-date columns and provides detailed error
reporting if any dates fail to parse.

### Excel Serial Numbers

`datefixR` supports both R and Excel numeric date representations:

``` r
# R serial dates (days since 1970-01-01)
r_serial <- "19539" # Represents 2023-07-01
fix_date_char(r_serial)
#> [1] "2023-07-01"

# Excel serial dates (days since 1900-01-01, accounting for Excel's leap year bug)
excel_serial <- "45108" # Also represents 2023-07-01
fix_date_char(excel_serial, excel = TRUE)
#> [1] "2023-07-01"

# Mixed serial and text dates
mixed_dates <- c("45108", "2023-07-01", "july 1 2023")
fix_date_char(mixed_dates, excel = TRUE)
#> [1] "2023-07-01" "2023-07-01" "2023-07-01"
```

This is particularly useful when importing data from Excel spreadsheets
where dates may have been converted to serial numbers.

### MDY vs DMY Detection

By default, `datefixR` assumes day-first (DMY) over month-first format
when the date order is ambiguous. However, you can specify month-first
(MDY) format:

``` r
# Ambiguous dates that could be interpreted as either MDY or DMY
ambiguous_dates <- c("01/02/2023", "03/04/2023", "05/06/2023")

# Default: Day-first (DMY) interpretation
dmy_result <- fix_date_char(ambiguous_dates)
print(dmy_result)
#> [1] "2023-02-01" "2023-04-03" "2023-06-05"

# Month-first (MDY) interpretation
mdy_result <- fix_date_char(ambiguous_dates, format = "mdy")
print(mdy_result)
#> [1] "2023-01-02" "2023-03-04" "2023-05-06"
```

### Missing Day/Month Imputation

`datefixR` provides flexible control over how missing date components
are imputed:

``` r
# Incomplete dates requiring imputation
incomplete_dates <- c("2023", "05/2023", "2023-08", "march 2022")

# Default imputation: missing month = July (07), missing day = 1st
default_impute <- fix_date_char(incomplete_dates)
print(default_impute)
#> [1] "2023-07-01" "2023-05-01" "2023-08-01" "2022-03-01"

# Custom imputation: missing month = January (01), missing day = 15th
custom_impute <- fix_date_char(incomplete_dates,
  month.impute = 1,
  day.impute = 15
)
print(custom_impute)
#> [1] "2023-01-15" "2023-05-15" "2023-08-15" "2022-03-15"

# For data frames, apply the same logic
incomplete_df <- data.frame(
  id = 1:4,
  dates = incomplete_dates
)

fixed_incomplete <- fix_date_df(incomplete_df, "dates",
  month.impute = 12, # December
  day.impute = 31
) # Last day
knitr::kable(fixed_incomplete)
```

| id | dates      |
| -: | :--------- |
|  1 | 2023-12-31 |
|  2 | 2023-05-31 |
|  3 | 2023-08-31 |
|  4 | 2022-03-31 |

This flexibility allows you to choose imputation strategies that make
sense for your specific use case (e.g., fiscal year starts, survey
periods, etc.).

### Roman Numerals

`datefixR` can handle Roman numerals being used to denote the month, a
format sometimes used by Oracle Database:

``` r
# Roman numeral months
roman_dates <- c(
  "15.VII.2023", # July 15, 2023
  "3.XII.1999", # December 3, 1999
  "1.I.2000" # January 1, 2000
)

fix_date_char(roman_dates, roman.numeral = TRUE)
#> [1] "2023-07-15" "1999-12-03" "2000-01-01"
```

Roman numeral support is experimental and has to be explicitly enabled
via `roman.numeral = TRUE`.

## Performance

This package has recently been optimized for speed using Rust and is now
over 300x faster than the largely pure R implementation used in previous
versions. Moreover, a fastpath approach has been implemented for common
date formats, further improving performance in most situations. Finally,
`fix_date_df()` now supports parallelism over columns via the `cores`
argument (or via the `'Ncpus'` global option). As such, speed is now
very unlikely to be an issue when using `datefixR` on large datasets.

## Limitations

Date and time data are often reported together in the same variable
(known as “datetime”). However datetime formats are not supported by
`datefixR`. The current rationale is this package is mostly used to
handle dates entered via free text web forms and it is much less common
for both date and time to be reported together in this input method.
However, if there is significant demand for support for datetime data in
the future this may added.

## Similar packages to datefixR

### `lubridate`

[`lubridate::guess_formats()`](https://lubridate.tidyverse.org/reference/guess_formats.html)
can be used to guess a date format and
[`lubridate::parse_date_time()`](https://lubridate.tidyverse.org/reference/parse_date_time.html)
calls this function when it attempts to parse a vector into a POSIXct
date-time object. However:

1.  When a date fails to parse in `{lubridate}` then the user is simply
    told how many dates failed to parse. In `datefixR` the user is told
    the ID (assumed to be the first column by default but can be
    user-specified) corresponding to the date which failed to parse and
    reports the considered date: making it much easier to figure out
    which dates supplied failed to parse and why.
2.  When imputing a missing day or month, there is no user-control over
    this behavior. For example, when imputing a missing month, the user
    may wish to impute July, the middle of the year, instead of January.
    However, January will always be imputed in `{lubridate}`. In
    `datefixR`, this behavior can be controlled by the `month.impute`
    argument.
3.  These functions require all possible date formats to be specified in
    the `orders` argument, which may result in a date format not being
    considered if the user forgets to list one of the possible formats.
    By contrast, `datefixR` only needs a format to be specified if
    month-first is to be preferred over day-first when guessing a date.

However, `{lubridate}` of course excels in general date manipulation and
is an excellent tool to use alongside `datefixR`.

### `anytime`

An alternative function is
[`anytime::anydate()`](https://dirk.eddelbuettel.com/code/anytime.html)
which also attempts to convert dates to a consistent format (POSIXct).
However `{anytime}` assumes year, month, and day have all been provided
and does not permit imputation. Moreover, if a date cannot be parsed,
then the date is converted to an NA object and no warning is raised-
which may lead to issues in any downstream analyses.

### `parsedate`

`parsedate::parse_date()` also attempts to solve the problem of handling
arbitrary dates and parses dates into the `POSIXct` type. Unfortunately,
`parse_date()` cannot handle years before 1970 – instead imputing the
year as the current year without any warnings being raised.

``` r
parsedate::parse_date("april 15 1969")
#> [1] "2025-04-15 UTC"
```

Moreover, `parse_date()` assumes dates are in MDY format and does not
allow the user to specify otherwise. However, `{parsedate}` has
excellent support for handling dates in ISO 8601 formats.

### `stringi`, `readr`, and `clock`

These packages all use [ICU
library](https://unicode-org.github.io/icu/userguide/format_parse/datetime/)
when parsing dates (via `stringi::stri_datetime_parse()`,
`readr::parse_date()`, or `clock::date_parse()`) and therefore all
behave very similarly. Notably, all of these functions require the date
format to be specified including specifying a priori if a date is
missing. Ultimately, this makes these packages unsuitable when numerous
dates in different formats must be parsed.

``` r
readr::parse_date("02/2010", "%m/%Y")
#> [1] "2010-02-01"
```

However, these packages have support for weekdays and months in around
211 locales whereas `datefixR` supports much fewer languages due to
support for additional languages needing to be implemented individually
and by hand.

**Trade-offs to consider:**

  - **`datefixR`**: Better error reporting, flexible imputation, handles
    mixed formats automatically. Fast.
  - **`lubridate`**: Requires format specification, limited imputation
    control  
  - **`stringi`/`readr`/`clock`**: Require exact format specification,
    supports 211 locales
  - **`anytime`**: Variable performance, no imputation support, silent
    failures

For messy, mixed-format data where usability and error handling are
priorities, `datefixR` shines. Now that the core logic is handled in
Rust, performance has improved significantly making it suitable for very
large datasets.

## Contributing to datefixR

If you are interested in contributing to `datefixR`, please read our
[contributing
guide](https://github.com/ropensci/datefixR/blob/main/.github/CONTRIBUTING.md).

Please note that this package is released with a [Contributor Code of
Conduct](https://ropensci.org/code-of-conduct/). By contributing to this
project, you agree to abide by its terms.

## Citation

If you use this package in your research, please consider citing
`datefixR`\! An up-to-date citation can be obtained by running

``` r
citation("datefixR")
```
