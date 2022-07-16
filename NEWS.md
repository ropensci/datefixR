<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

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

