
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datefixR <img src="man/figures/sticker.png" align="right" width="150" />

<!-- badges: start -->

[![R build
status](https://github.com/nathansam/datefixR/workflows/R-CMD-check/badge.svg)](https://github.com/nathansam/datefixR/actions)
[![codecov](https://codecov.io/gh/nathansam/datefixR/branch/main/graph/badge.svg?token=lb83myWBXt)](https://app.codecov.io/gh/nathansam/datefixR)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/datefixR)](https://cran.r-project.org/package=datefixR)
![Top
language](https://img.shields.io/github/languages/top/nathansam/datefixR)
[![License:
GPL-3](https://img.shields.io/badge/License-GPL3-green.svg)](https://opensource.org/licenses/GPL-3.0)
<!-- badges: end -->

`datefixR` is designed to standardize messy date data, such as dates
entered by different people via text boxes, by converting the dates to
R’s Date data type.

This package arose from my own fights with messy date data where dates
were written in many different formats e.g 01-jan-15, 2015 04 02,
10/12/2010 and more.

## Installation instructions

The development version of `datefixR` can be installed via

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("nathansam/fixdateR")
```

### Usage

``` r
library(datefixR)
bad.dates <- data.frame(id = seq(5),
                        some.dates = c("02/05/92",
                                       "01-04-2020",
                                       "1996/05/01",
                                       "2020-05-01",
                                       "02-04-96"),
                        some.more.dates = c("2015",
                                            "02/05/00",
                                            "05/1990",
                                            "2012-08",
                                            "jan 2020")
                        )
fixed.df <- fix_dates(bad.dates, c("some.dates", "some.more.dates"))
knitr::kable(fixed.df)
```

|  id | some.dates | some.more.dates |
|----:|:-----------|:----------------|
|   1 | 1992-05-02 | 2015-07-01      |
|   2 | 2020-04-01 | 2000-05-02      |
|   3 | 1996-05-01 | 1990-05-01      |
|   4 | 2020-05-01 | 2012-08-01      |
|   5 | 1996-04-02 | 2020-01-01      |

By default, `datefixR` imputes missing days of the month as 01, and
missing months as 07 (July). However, this behavior can be modified via
the `day.impute` or `month.impute` arguments.

``` r
 example.df <- data.frame(example = "1994")

fix_dates(example.df, "example", month.impute = 1)
#>      example
#> 1 1994-01-01
```

### Limitations

The US date format of month first is not currently supported. This may
change in the future by passing an additional argument to the function
call.

The package is written solely in R and seems fast enough for my current
use cases (a few hundred rows). However, I may convert the core for loop
to C++ in the future if I (or others) need it to be faster.
