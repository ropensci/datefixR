#' @title Convert non-standardized dates to \R{}'s \code{Date} class
#' @description
#' Converts a character vector (or single character object) from inconsistently
#' formatted dates to \R{}'s \code{Date} class. Supports numerous separators
#' including /, -, ., or space. Supports numeric, abbreviation, or long-hand
#' month notation in multiple languages (English, French, German, Spanish,
#' Portuguese, Russian, Czech, Slovak, Indonesian). Where day of the month has
#' not been supplied, the first day of the month is imputed by default. Either
#' DMY or YMD is assumed by default. However, the US system of MDY is supported
#' via the \code{format} argument.
#'
#' @details
#' This function intelligently parses dates by:
#' \itemize{
#'   \item{Handling mixed separators within the same dataset}
#'   \item{Recognizing month names in multiple languages}
#'   \item{Converting Roman numeral months (experimental)}
#'   \item{Processing Excel serial date numbers}
#'   \item{Automatically detecting YMD format when year appears first}
#'   \item{Smart imputation of missing date components with user control}
#' }
#'
#' For comprehensive examples and advanced usage, see \code{browseVignettes("datefixR")}
#' or the package README at \url{https://docs.ropensci.org/datefixR/}.
#'
#' @param dates Character vector to be converted to \R{}'s date class.
#' @param day.impute Integer between 1 and 31, or NA, or NULL. Day of the month
#'   to be imputed when missing. Defaults to 1. If \code{day.impute = NA}, then
#'   \code{NA} will be imputed for the date and a warning will be raised. If
#'   \code{day.impute = NULL}, the function will fail with an error when day is
#'   missing.
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
#' @inheritParams fix_date_df
#' @return A vector of elements belonging to \R{}'s built in \code{Date} class
#'   with the following format \code{yyyy-mm-dd}.
#' @seealso
#' \code{\link{fix_date_df}} for data frame columns with date data.
#'
#' For detailed examples and usage patterns, see:
#' \itemize{
#'   \item{Package vignette: \code{browseVignettes("datefixR")}}
#'   \item{Online documentation: \url{https://docs.ropensci.org/datefixR/articles/datefixR.html}}
#'   \item{Package README: \url{https://docs.ropensci.org/datefixR/}}
#' }
#' @examples
#' # Basic usage
#' bad.date <- "02 03 2021"
#' fix_date_char(bad.date)
#'
#' # Multiple formats with different separators
#' mixed_dates <- c(
#'   "02/05/92", # slash separator, 2-digit year
#'   "2020-may-01", # hyphen separator, text month
#'   "1996.05.01", # dot separator
#'   "02 04 96", # space separator
#'   "le 3 mars 2013" # French format
#' )
#' fix_date_char(mixed_dates)
#'
#' # Text months in different languages
#' text_months <- c(
#'   "15 January 2020", # English
#'   "15 janvier 2020", # French
#'   "15 Januar 2020", # German
#'   "15 enero 2020", # Spanish
#'   "15 de janeiro de 2020" # Portuguese
#' )
#' fix_date_char(text_months)
#'
#' # Roman numeral months (experimental)
#' roman_dates <- c("15.VII.2023", "3.XII.1999", "1.I.2000")
#' fix_date_char(roman_dates, roman.numeral = TRUE)
#'
#' # Excel serial numbers
#' excel_serials <- c("44197", "44927") # Excel dates
#' fix_date_char(excel_serials, excel = TRUE)
#'
#' # Two-digit years (automatic century detection)
#' two_digit_years <- c("15/03/99", "15/03/25", "15/03/50")
#' fix_date_char(two_digit_years) # 1999, 2025, 1950
#'
#' # MDY format (US style)
#' us_dates <- c("12/25/2023", "07/04/1776", "02/29/2020")
#' fix_date_char(us_dates, format = "mdy")
#'
#' # Incomplete dates with custom imputation
#' incomplete <- c("2023", "March 2022", "June 2021")
#' fix_date_char(incomplete, day.impute = 15, month.impute = 6)
#'
#' @export
fix_date_char <- function(
    dates,
    day.impute = 1,
    month.impute = 7,
    format = "dmy",
    excel = FALSE,
    roman.numeral = FALSE) {
  # Handle NA input early
  if (length(dates) == 1 && is.na(dates)) {
    return(as.Date(NA))
  }

  # Check non-character input
  if (!is.character(dates)) {
    stop("date should be a character \n")
  }

  # Check day.impute and handle extendr errors
  checkday_result <- checkday(day.impute)
  if (inherits(checkday_result, "extendr_error")) {
    error_msg <- if ("value" %in% names(checkday_result)) {
      checkday_result$value
    } else {
      as.character(checkday_result)
    }
    stop(error_msg, call. = FALSE)
  }

  .checkmonth(month.impute)
  .checkformat(format)

  # Handle NA day.impute by issuing warning
  if (is.na(day.impute)) {
    warning("NA imputed", call. = FALSE)
  }

  # Convert imputation values to integers for Rust
  # Pass -1 as a sentinel value for NULL/NA, which Rust will interpret as None
  day_impute_int <- if (is.na(day.impute) || is.null(day.impute)) -1L else as.integer(day.impute)
  month_impute_int <- if (is.na(month.impute) || is.null(month.impute)) -1L else as.integer(month.impute)

  # Pre-process data to handle NA and empty values
  date_data <- as.character(dates)
  na_indices <- is.na(date_data) | date_data == "" | date_data == "NA"

  # Only process non-NA values through Rust
  if (all(na_indices)) {
    # All values are NA, return all NAs
    fixed_dates <- rep(list(NULL), length(date_data))
  } else {
    # Replace NA values with placeholder for processing
    processed_data <- date_data
    processed_data[na_indices] <- "1999-01-01" # Temporary placeholder

    # Call Rust backend for efficient processing
    fixed_dates <- .Call(
      "wrap__fix_date_column",
      processed_data,
      day_impute_int,
      month_impute_int,
      NULL, # no subjects for character vector processing
      format,
      excel,
      roman.numeral
    )

    # Restore NA values in the result
    if (is.list(fixed_dates)) {
      fixed_dates[na_indices] <- list(NULL)
    } else if (is.vector(fixed_dates)) {
      # Handle case where fixed_dates is a vector
      fixed_dates[na_indices] <- NA
    }
  }

  # Check if the result is an error condition from extendr
  if (inherits(fixed_dates, "extendr_error")) {
    # Extract the error message and throw it as a proper R error
    error_msg <- if ("value" %in% names(fixed_dates)) {
      fixed_dates$value
    } else {
      as.character(fixed_dates)
    }
    stop(error_msg, call. = FALSE)
  }

  # Convert to Date class, handling NULL values from Rust
  result <- as.Date(sapply(fixed_dates, function(x) if (is.null(x)) NA_character_ else x))

  # Remove names to match expected output
  names(result) <- NULL

  result
}
