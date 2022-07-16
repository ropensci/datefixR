#' @title Clean up messy date columns
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' Cleans up a \code{dataframe} object which has date columns
#' entered via a free-text box (possibly by different users) and are therefore
#' in a non-standardized format. Supports numerous separators including /,-, or
#' space. Supports all-numeric, abbreviation, or long-hand month notation. Where
#' day of the month has not been supplied, the first day of the month is
#' imputed. Either DMY or YMD is assumed by default. However, the US system of
#' MDY is supported via the \code{format} argument.
#' @param df A \code{dataframe} or \code{tibble} object with messy date
#'   column(s)
#' @param col.names Character vector of names of columns of messy date data
#' @param id Name of column containing row IDs. By default, the first column is
#'   assumed.
#' @param day.impute Integer. Day of the month to be imputed if not available.
#'   defaults to 1. If \code{day.impute = NA} then \code{NA} will be imputed for
#'   the date instead and a warning will be raised. If \code{day.impute = NULL}
#'   then instead of imputing the day of the month, the function will fail
#' @param month.impute Integer. Month to be be imputed if not available.
#'   Defaults to 7 (July). If \code{month.impute = NA} then \code{NA} will be
#'   imputed for the date instead and a warning will be raised. If
#'   \code{month.impute = NULL} then instead of imputing the month, the
#'   function will fail.
#' @param format Character. The format which a date is mostly likely to be given
#'   in. Either \code{"dmy"} (default) or \code{"mdy"}. If year appears to have
#'   been given first, then YMD is assumed for the subject (format argument is
#'   not used for these observations)
#' @return A \code{dataframe} or \code{tibble} object. Dependent on the type of
#'   \code{df}. Selected columns are of type \code{Date}
#' @seealso \code{\link{fix_date}} Similar to \code{fix_dates()} except can only
#' be applied to character objects.
#' @examples
#' bad.dates <- data.frame(
#'   id = seq(5),
#'   some.dates = c(
#'     "02/05/92",
#'     "01-04-2020",
#'     "1996/05/01",
#'     "2020-05-01",
#'     "02-04-96"
#'   ),
#'   some.more.dates = c(
#'     "2015",
#'     "02/05/00",
#'     "05/1990",
#'     "2012-08",
#'     "jan 2020"
#'   )
#' )
#' fixed.df <- fix_dates(bad.dates, c("some.dates", "some.more.dates"))
#' # ->
#' fixed.df <- fix_date_df(bad.dates, c("some.dates", "some.more.dates"))
#' @keywords internal
#' @export
fix_dates <- function(df,
                      col.names,
                      day.impute = 1,
                      month.impute = 7,
                      id = NULL,
                      format = "dmy") {
  lifecycle::deprecate_warn("1.0.0", "fix_dates()", "fix_date_df()")
  fix_date_df(
    df = df,
    col.names = col.names,
    day.impute = day.impute,
    month.impute,
    id = id,
    format = format
  )
}
