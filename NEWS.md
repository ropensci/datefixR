# datefixR 0.1.6.9000 (ropensci peer review)

## Editor checks
Addressed the below issues `{lintr}` found:

* Avoid `1:nrow(...)` expressions, use `seq_len`.
* lines of code >80 chars

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

