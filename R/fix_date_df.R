#' @title Clean up messy date columns
#' @description Tidies a \code{dataframe} or \code{tibble} object with date
#' columns entered via a free-text interface, addressing non-standardized
#' formats. Supports diverse separators including /, -, ., and spaces. Handles
#' all-numeric, abbreviated, or full-length month names in languages such as
#' English, French, German, Spanish,  Portuguese, Russian, Czech, Slovak, and
#' Indonesian. Imputes missing day data by  default, with flexibility for custom
#' imputation strategies.
#'
#' @details
#' This function processes messy date data by:
#' \itemize{
#'   \item{Supporting mixed format data entries}
#'   \item{Recognizing multilingual month names and Roman numeral inputs}
#'   \item{Interpreting Excel-style serial date numbers if specified}
#'   \item{Providing warnings and controls for missing day/month imputation}
#' }
#' For further details and advanced usage, refer to the vignette via
#' \code{browseVignettes("datefixR")} or visit the online documentation at
#' \url{https://docs.ropensci.org/datefixR/}.
#'
#' @param df A \code{dataframe} or \code{tibble} object containing messy date
#'   column(s).
#' @param col.names Character vector specifying column names of date data to be
#'   cleaned.
#' @param id Optional parameter specifying the name of the column containing
#'   row IDs. Defaults to using the first column for IDs.
#' @param day.impute Integer between 1 and 31, or NA, or NULL. Day of the month
#'   to be imputed when missing. Defaults to 1. If \code{day.impute} is greater
#'   than the number of days in a given month, the last day of that month will
#'   be imputed (accounting for leap years). If \code{day.impute = NA}, then
#'   \code{NA} will be imputed for the entire date and a warning will be raised.
#'   If \code{day.impute = NULL}, the function will fail with an error when day
#'   is missing.
#' @param month.impute Integer between 1 and 12, or NA, or NULL. Month to be
#'   imputed when missing. Defaults to 7 (July). If \code{month.impute = NA},
#'   then \code{NA} will be imputed for the entire date and a warning will be
#'   raised.
#'   If \code{month.impute = NULL}, the function will fail with an error when
#'   month is missing.
#' @param format Character string specifying date interpretation preference.
#'   Either \code{"dmy"} (day-month-year, default) or \code{"mdy"}
#'   (month-day-year, US format). This setting only affects ambiguous numeric
#'   dates like "01/02/2023". When month names are present or year appears
#'   first, the format is auto-detected regardless of this parameter. Note that
#'   unambiguous dates (e.g., "25/12/2023") are parsed correctly regardless of
#'   the format setting.
#' @param excel Logical: Assumes \code{FALSE} by default. If \code{TRUE}, treats
#'   numeric-only dates with more than four digits as Excel serial dates with
#'   1900-01-01 origin, correcting for known Excel date discrepancies.
#' @param roman.numeral `r lifecycle::badge("experimental")` Logical: Defaults
#'   to \code{FALSE}. When \code{TRUE}, attempts to interpret Roman numeral
#'   month indications within datasets. This feature may not handle all cases
#'   correctly.
#' @return A revised \code{dataframe} or \code{tibble} structure, maintaining
#'   input type. Date columns will be formatted with \code{Date} class and
#'   display as \code{yyyy-mm-dd}.
#' @seealso
#' \code{\link{fix_date_char}} for similar functionality on character vectors
#' and \code{\link{fix_date}} for single date entries.
#'
#' For comprehensive examples and usage practices, consult:
#' \itemize{
#'   \item{Vignette: \code{browseVignettes("datefixR")}}
#'   \item{Documentation: \url{https://docs.ropensci.org/datefixR/articles/datefixR.html}}
#'   \item{README Overview: \url{https://docs.ropensci.org/datefixR/}}
#' }
#' @examples
#' # Basic cleanup
#' data(exampledates)
#' fix_date_df(exampledates, c("some.dates", "some.more.dates"))
#'
#' # Usage with metadata
#' messy_dates_df <- data.frame(
#'   id = seq(1, 3),
#'   dates = c("1992", "April 1990", "Mar 19")
#' )
#' fix_date_df(messy_dates_df, "dates", day.impute = 15, month.impute = 12)
#'
#' # Diverse format normalization
#' df_formats <- data.frame(
#'   mixed.dates = c("02/05/92", "2020-may-01", "1996.05.01", "October 2022"),
#'   european.dates = c("22.07.1977", "05.06.2023")
#' )
#' fix_date_df(df_formats, c("mixed.dates", "european.dates"))
#'
#' # Excel serial examples
#' serial_df <- data.frame(serial.dates = c("44197", "44927"))
#' fix_date_df(serial_df, "serial.dates", excel = TRUE)
#'
#' # Handling Roman numerals
#' roman_df <- data.frame(roman.dates = c("15.I.2023", "03.XII.2019"))
#' fix_date_df(roman_df, "roman.dates", roman.numeral = TRUE)
#' @export
fix_date_df <- function(
    df,
    col.names,
    day.impute = 1,
    month.impute = 7,
    id = NULL,
    format = "dmy",
    excel = FALSE,
    roman.numeral = FALSE) {
  if (!is.data.frame(df)) {
    stop("df should be a dataframe object!")
  }
  if (any(!is.character(col.names))) {
    stop("col.names should be a character vector!")
  }
  .checkformat(format)

  if (is.null(id)) {
    id <- 1
  } # Use first column as id if not explicitly given

  checkday(day.impute)
  .checkmonth(month.impute)
  day.impute <- .convertimpute(day.impute)
  month.impute <- .convertimpute(month.impute)
  for (col.name in col.names) {
    fixed.dates <- c()
    for (i in seq_len(nrow(df))) {
      tryCatch(
        {
          fixed.dates[i] <- .fix_date(
            df[i, col.name],
            day.impute,
            month.impute,
            subject = df[i, id],
            format = format,
            excel = excel,
            roman.numeral = roman.numeral
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
