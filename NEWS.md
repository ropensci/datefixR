<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# datefixR 1.7.0

* Indonesian translations and months have been added thanks to Chitra M
  Saraswati (@chitrams on GitHub).

# datefixR 1.6.1

## Code changes

* Added 'ene' and 'ener' as alternative names for January (thanks to
  @Guallasamin)

# datefixR 1.6.0

## Code changes

* If `day.impute` is greater than the number of days for a given month, then
  the last day of that month will be imputed. This will also take into account
  there are 29 days in February in leap years. Setting `day.impute = 31` ensures
  the last day of the month will always be imputed if the day is missing. 
* An error is raised if the provided day of the year is greater than 31. 
* Czech and Slovak translations have been added thanks to @MichalLauer.

## Documentation

Package help file is now auto-generated.

# datefixR 1.5.0

## Code changes

* `exampledates` has been updated to now include dates in non-English formats
* Russian translations and dates have been added thanks to @atsyplenkov.
* Fixed a bug which would cause R to freeze on Windows machines when datefixR
  had been built using Rtools 43. 
* Experimental support has been added for months given as Roman numerals.
* A message raised if the system locale does not support multibyte
  characters has been translated (thanks @KittJonathan, @dpprdan, and @ajpelu)
  (100% translation of all user-facing messages).

## Documentation

* README now lists localized date support. 
* README badges have been added for translation status
* The vignette now discusses parsing dates with Roman numerals.

# datefixR 1.4.1

## Code changes

* The warning raised if `datefixR` is used with a locale which does not accept
  multibyte characters now only occurs when the package is loaded using
  `library()`. 
* Fixed a bug where dates with single digit day and double digit year would fail
* Fixed a bug where numeric dates converted from Excel were slightly off
  (this is because Excel incorrectly regards 1900 as a leap year).

# datefixR 1.4.0

## Code changes

Support has been added for parsing dates converted to a numeric format by
Excel. Unlike R which converts `Date` objects to numeric by calculating the
number of days since `1970-01-01`, Excel typically converts date cells to
numeric cells by calculating the number of days since `1900-01-01`. `datefixR`
can be told to expect dates converted by Excel instead of R by passing
`excel = TRUE` to `datefixR`'s functions. 

In `datefixR` 1.3.1, internal functions began to be converted to C++. This
process unintentionally led to translations of some user-facing messages not
being delivered to users. This bug has now been fixed.

## Documentation

Added function documentation for the new `excel` argument and updated the "Getting
Started" vignette with a section on converting numeric dates. 

# datefixR 1.3.1

## Code changes

A warning is now raised if datefixR is used with a locale which does not support
multibyte characters. Tests for months names in different languages now first
check if multibyte characters are supported before running. 

# datefixR 1.3.0

## Code changes

Tests have been refactored: making it easier for others to contribute their own 
tests. See [#57](https://github.com/ropensci/datefixR/pull/57).

## Documentation

- Now discuss more R packages similar to `datefixR` in README
- Warnings and errors have been translated to German thanks to Daniel
  Possenriede (@dpprdan on GitHub)
- Fixes typo in README for the German language (now "Deutsch") 

# datefixR 1.2.0

## Code changes

* Added much wider support for date formats commonly seen in regions where
  English is not the first language (de and del, "1er" "le" etc.) . 
* Months with Portuguese names are now recognized. 
* "." and ".'" separators are now supported.
* Support has been added for dates with ordinals ("1st", "2nd", etc.)
* `datefixR` will now recognize when a month-first date is given (without
  needing the `format` argument to be explicitly provided) if the month is
  given by name e.g "July 4th, 1776"
  

* Thanks to community submissions, error messages and warnings have now been
  translated to French and Spanish. These messages should automatically be
  delivered instead of the English language versions based on the locale
  detected by R. 
  * French errors/warnings were translated by Jonathan Kitt (@KittJonathan on
    GitHub)
  * Spanish errors/warnings were translated by Antonio J Perez-Luque (@ajpelu on
    GitHub)


## Documentation

The README file now mentions which languages `datefixR` currently supports. 


# datefixR 1.1.0

This update introduces a Shiny app and support for names of months in Spanish,
German, and French.

## Code changes

* New function, `fix_date_app()` which produces a shiny app for accessing
  the features of `datefixR`. Please note, the package dependencies for this app
  (`DT`, `htmltools`, `readxl`, and `shiny`) are not installed alongside
  `datefixR`. This allows datefixR to be installed on secure systems where these
  packages may not be allowed. If one of these dependencies is not installed on
  the system when this function is called, then the user will have the option of
  installing them.
* Behind the scenes, names for months of the year are now handled differently to
  allow multilingual support. Spanish, German, and French is currently supported
  with the option to support additional languages in the future.
  
## Documentation

* The README now uses an animation from
  [`asciicast`](https://CRAN.R-project.org/package=asciicast) to demonstrate the
  package. 

# datefixR 1.0.0

For this revision, `datefixR` has undergone
[ropensci peer review](https://github.com/ropensci/software-review/issues/533)
which has resulted in substantial changes and improvements to the package. My
sincerest thanks to the reviewers, Kaique dos S. Alves and Al-Ahmadgaid B.
Asaad, and the editor, Adam H. Sparks.  

## Code changes

* `fix_date()` and `fix_dates()` have been deprecated in favor of
  `fix_date_char()` and `fix_date_df()` respectively to make the role of each 
  function clearer. The deprecated functions will continue to work but are not
  guaranteed to have new features. Users will be gently encouraged to transition
  to the new functions. 
* `fix_date_char()` now supports vectors as well as character objects of length 1.
  This also means `fix_date_char()` can be used with `dplyr::mutate()`.
* An example data frame for using with the package functions, `exampledates`, is
  now provided with the package. 
  
## Documentation

* The package description has been changed to make the purpose of the package 
  clearer.
* Instead of "cleans up", fix_date_df() is now described as "tidying" a data
  frame. 
* Lack of support for the datetime format has been added to the README file
* The package repository is now owned by the ropensci GitHub organization and
  all links have been changed accordingly.

## Testing

* Tests now expect specific warnings rather than warnings with any message. 

# datefixR 0.1.6

* Dates with a "sept" / "Sept" abbreviation will now be correctly handled.
* Lint all R files using styler

# datefixR 0.1.4

* Update documentation to reflect support for MM/DD/YYYY formats and `NA`
  imputation

# datefixR 0.1.3

* Added support for MM/DD/YYYY formats via an optional argument, `format`.

# datefixR 0.1.2

* Added `id` argument to `fix_dates()`. If not explicitly stated, the first
  column is assumed to contain row IDs.
* Added more useful error messages which provide both the date causing the
  error, and the associated ID. 
* Setting `day.impute = NA` or `month.impute = NA` will now result in NA if day
  or month is missing respectively in a date and a warning is issued. If
  `day.impute = NULL` or `month.impute = NULL` then the function will error if
  day or month is missing respectively in a date
* Added `datefixR` vignette which describes the package in more detail than the
  README
* Added `fix_date()` for fixing individual dates.
* Added citation file
  
# datefixR 0.1.1

* First version of the package
* Added a `NEWS.md` file to track changes to the package.

