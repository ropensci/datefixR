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

