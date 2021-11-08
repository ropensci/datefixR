# datefixR 0.1.2

* Added `id` argument to `fix_dates()`. If not explicitly stated, the first
  column is assumed to contain row IDs.
* Added more useful error messages which provide both the date causing the
  error, and the associated ID. 
* If `NULL` is given for `day.impute` or `month.impute` then
  `fix_dates()` will error if there are any missing values for either day or
  month respectively. If `NA` is given for `day.impute` or `month.impute` then
  `fix_dates()` will impute NA for any missing values for either day or
  month respectively   
  
# datefixR 0.1.1

* First version of the package
* Added a `NEWS.md` file to track changes to the package.

