<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# datefixR 1.2.0

## Code changes

* Added much wider support for date formats commonly seen in regions where
  English is not the first language (de and del, "1er" "le" etc.) . 
* Months with Portuguese names are now recognized. 
* "." and ".'" separators are now supported.
* Support has been added for dates with ordinals ("1st", "2nd", etc. )
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

