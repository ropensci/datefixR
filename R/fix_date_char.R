#' @title Convert improperly formatted date to \R{}'s Date class
#' @description
#' Converts a character vector (or single character object)  from improperly
#' formatted dates to \R{}'s Date class. Supports numerous separators including
#' /, -, or white space. Supports all-numeric, abbreviation or long-hand month
#' notation. Where day of the month has not been supplied, the first day of the
#' month is imputed by default. Either DMY or YMD is assumed by default.
#' However, the US system of MDY is supported via the \code{format} argument.
#' @param dates Character vector to be converted to \R{}'s date class.
#' @inheritParams fix_date_df
#' @return A vector of elements belonging to \R{}'s built in \code{Date} class
#'   with the following format \code{yyyy-mm-dd}.
#' @seealso \code{\link{fix_date_df}} which is similar to \code{fix_date_char()}
#' except is applicable to columns of a data frame.
#' @examples
#' bad.date <- "02 03 2021"
#' fixed.date <- fix_date_char(bad.date)
#' fixed.date
#' @export
fix_date_char <- function(dates,
                          day.impute = 1,
                          month.impute = 7,
                          format = "dmy",
                          excel = FALSE) {
  checkday(day.impute)
  .checkmonth(month.impute)
  .checkformat(format)
  as.Date(
    sapply(
      dates,
      .fix_date_char,
      day.impute = day.impute,
      month.impute = month.impute,
      format = format,
      excel = excel,
      USE.NAMES = FALSE
    ),
    origin = "1970-01-01"
  )
}
