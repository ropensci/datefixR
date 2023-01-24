#' @title Clean up messy date columns
#' @description Tidies a \code{dataframe} object which has date columns
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
#' @param excel Logical. If a date is given as only numbers (no separators), and
#'   is more than four digits, should the date be assumed to be from Excel
#'   which counts the number of days from 1900-01-01? In most programming
#'   languages (including R), days are instead calculated from 1970-01-01
#'   and this is the default for this function (\code{excel = FALSE})
#' @return A \code{dataframe} or \code{tibble} object. Dependent on the type of
#'   \code{df}. Selected columns are of type \code{Date} with the following
#'   format \code{yyyy-mm-dd}
#' @seealso \code{\link{fix_date_char}} which is similar to \code{fix_date_df()}
#'   except can only be applied to character vectors.
#' @examples
#' data(exampledates)
#' fixed.df <- fix_date_df(exampledates, c("some.dates", "some.more.dates"))
#' fixed.df
#' @export
fix_date_df <- function(df,
                        col.names,
                        day.impute = 1,
                        month.impute = 7,
                        id = NULL,
                        format = "dmy",
                        excel = FALSE) {
  if (!is.data.frame(df)) {
    stop("df should be a dataframe object!")
  }
  if (any(!is.character(col.names))) {
    stop("col.names should be a character vector!")
  }
  .checkformat(format)

  if (is.null(id)) id <- 1 # Use first column as id if not explicitly given

  checkday(day.impute)
  .checkmonth(month.impute)
  day.impute <- .convertimpute(day.impute)
  month.impute <- .convertimpute(month.impute)
  for (col.name in col.names) {
    fixed.dates <- c()
    for (i in seq_len(nrow(df))) {
      tryCatch(
        {
          fixed.dates[i] <- .fix_date(df[i, col.name],
            day.impute,
            month.impute,
            subject = df[i, id],
            format = format,
            excel = excel
          )
        },
        error = function(cond) {
          message(paste0(
            "Unable to resolve date for subject ",
            df[i, id],
            " (date: ",
            df[i, col.name],
            ")\n"
          ))
          stop(cond)
        }
      )
    }
    df[, col.name] <- as.Date(fixed.dates)
  }
  df
}
