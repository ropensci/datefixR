#' @title Convert improperly formatted date to R's Date class
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' Converts a single improperly formatted date to \R{}'s Date class.
#' Supports numerous separators including /,- or white space.
#' Supports all-numeric, abbreviation or long-hand month notation. Where
#' day of the month has not been supplied, the first day of the month is
#' imputed. Either DMY or YMD is assumed by default. However, the US system of
#' MDY is supported via the \code{format} argument.
#' @param date Character to be converted to \R{}'s date class.
#' @inheritParams fix_dates
#' @return An object belonging to \R's built in \code{Date} class.
#' @seealso \code{\link{fix_dates}} Similar to \code{fix_date()} except is
#' applicable to columns of a dataframe.
#' @examples
#' bad.date <- "02 03 2021"
#' fixed.date <- fix_date(bad.date)
#' fixed.date
#' # ->
#' fixed.date <- fix_date_char(bad.date)
#' @keywords internal
#' @export
fix_date <- function(date, day.impute = 1, month.impute = 7, format = "dmy") {
  lifecycle::deprecate_warn("1.0.0", "fix_date()", "fix_date_char()")
  fix_date_char(
    dates = date,
    day.impute = day.impute,
    month.impute,
    format = format
  )
}
