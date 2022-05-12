#' @title Convert improperly formatted date to R's Date class
#' @description Converts a single improperly formatted date to R's Date class
#' Supports numerous separators including /,- or white space.
#' Supports all-numeric, abbreviation or long-hand month notation. Where
#' day of the month has not been supplied, the first day of the month is
#' imputed. Either DMY or YMD is assumed by default. However, the US system of
#' MDY is supported via the \code{format} argument.
#' @param date Character to be converted to R's date class.
#' @inheritParams fix_dates
#' @return An object belonging to R's built in \code{Date} class.
#' @seealso \code{\link{fix_dates}} Similar to \code{fix_date()} except is
#' applicable to columns of a dataframe.
#' @examples
#' bad.date <- "02 03 2021"
#' fixed.date <- fix_date(bad.date)
#' fixed.date
#' @export
fix_date <- function(date, day.impute = 1, month.impute = 7, format = "dmy") {
  if (is.null(date) || is.na(date) || as.character(date) == "") {
    return(NA)
  }

  if (!is.character(date)) stop("date should be a character \n")

  .checkday(day.impute)
  .checkmonth(month.impute)
  .checkformat(format)
  day.impute <- .convertimpute(day.impute)
  month.impute <- .convertimpute(month.impute)

  date <- as.character(date)
  date <- .convert_text_month(date)

  if (nchar(date) == 4) {
    # Just given year
    year <- date
    month <- .imputemonth(month.impute)
    day <- .imputeday(day.impute)
  } else {
    date_vec <- .separate_date(date)
    if (any(nchar(date_vec) > 4)) {
      stop("unable to tidy a date")
    }
    date_vec <- .appendyear(date_vec)
    if (length(date_vec) < 3) {
      # ASSUME MM/YYYY, YYYY/MM
      day <- .imputeday(day.impute)
      if (nchar(date_vec[1]) == 4) {
        # Assume YYYY/MM
        year <- date_vec[1]
        month <- date_vec[2]
      } else if (nchar(date_vec[2]) == 4) {
        year <- date_vec[2]
        month <- date_vec[1]
      }
    } else {
      if (nchar(date_vec[1]) == 4) {
        # Assume YYYY/MM/DD
        year <- date_vec[1]
        month <- date_vec[2]
        day <- date_vec[3]
      } else {
        if (format == "dmy") {
          # Assume DD/MM/YYYY
          year <- date_vec[3]
          month <- date_vec[2]
          day <- date_vec[1]
        }
        if (format == "mdy") {
          year <- date_vec[3]
          month <- date_vec[1]
          day <- date_vec[2]
        }
      }
    }
  }
  .checkoutput(day, month)
  as.Date(.combinepartialdate(day, month, year))
}
