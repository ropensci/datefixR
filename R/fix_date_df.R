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
#' @param cores Integer: Number of CPU cores to use for parallel processing.
#'   Defaults to \code{getOption("Ncpus", 1)}. When \code{cores > 1}, processes
#'   multiple date columns in parallel using the \code{future} framework.
#'   Requires the \code{future} and \code{future.apply} packages to be installed.
#'   The actual number of workers used will be the minimum of \code{cores} and
#'   the number of columns to process.
#' @return A revised \code{dataframe} or \code{tibble} structure, maintaining
#'   input type. Date columns will be formatted with \code{Date} class and
#'   display as \code{yyyy-mm-dd}.
#' @seealso
#' \code{\link{fix_date_char}} for similar functionality on character vectors.
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
#'
#' # Parallel processing (requires 'future' and 'future.apply' packages)
#' \dontrun{
#' large_df <- data.frame(
#'   dates1 = c("01/02/2020", "15/03/2021", "22/12/2019"),
#'   dates2 = c("2020-01-01", "March 2021", "Dec 2019"),
#'   dates3 = c("01.01.20", "15.03.21", "22.12.19")
#' )
#' # Use 4 cores for parallel processing
#' fix_date_df(large_df, c("dates1", "dates2", "dates3"), cores = 4)
#'
#' # Use all available cores (respects getOption("Ncpus"))
#' options(Ncpus = parallel::detectCores())
#' fix_date_df(large_df, c("dates1", "dates2", "dates3"))
#' }
#' @export
fix_date_df <- function(
    df,
    col.names,
    day.impute = 1,
    month.impute = 7,
    id = NULL,
    format = "dmy",
    excel = FALSE,
    roman.numeral = FALSE,
    cores = getOption("Ncpus", 1)) {
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

  # Note: NA values in input data are handled by the Rust backend and converted to NA dates

  # Handle NULL values first - these should throw errors immediately
  if (is.null(day.impute)) {
    stop("Missing day with no imputation value given \n", call. = FALSE)
  }
  if (is.null(month.impute)) {
    stop("Missing month with no imputation value given \n", call. = FALSE)
  }

  # Check day.impute for valid values (but only if not NA)
  if (!is.na(day.impute)) {
    checkday_result <- checkday(day.impute)
    if (inherits(checkday_result, "extendr_error")) {
      error_msg <- if ("value" %in% names(checkday_result)) {
        checkday_result$value
      } else {
        as.character(checkday_result)
      }
      stop(error_msg, call. = FALSE)
    }
  }

  .checkmonth(month.impute)

  # Convert imputation values to integers for Rust
  # Pass -1 as a sentinel value for NA, which Rust will interpret as a special case
  day_impute_int <- if (is.na(day.impute)) -1L else as.integer(day.impute)
  month_impute_int <- if (is.na(month.impute)) -1L else as.integer(month.impute)

  # Function to process a single column
  process_column <- function(col.name) {
    # Pre-process data to handle NA and empty values
    date_data <- as.character(df[[col.name]])
    na_indices <- is.na(date_data) | date_data == "" | date_data == "NA"

    # Only process non-NA values through Rust
    if (all(na_indices)) {
      # All values are NA, return all NAs
      fixed.dates <- rep(list(NULL), length(date_data))
    } else {
      # Replace NA values with placeholder for processing
      processed_data <- date_data
      processed_data[na_indices] <- "1999-01-01" # Temporary placeholder

      subjects <- if (is.numeric(id) && id <= ncol(df)) as.character(df[[id]]) else NULL

      # Call Rust backend
      fixed.dates <- .Call(
        "wrap__fix_date_column",
        processed_data,
        day_impute_int,
        month_impute_int,
        subjects,
        format,
        excel,
        roman.numeral
      )

      # Generate warnings for NA imputation when day.impute or month.impute is NA
      day_is_na <- !is.null(day.impute) && is.na(day.impute)
      month_is_na <- !is.null(month.impute) && is.na(month.impute)
      if (day_is_na || month_is_na) {
        for (i in seq_along(fixed.dates)) {
          if (is.null(fixed.dates[[i]]) || is.na(fixed.dates[[i]])) {
            # This date resulted in NA, generate appropriate warning
            original_date <- date_data[i] # Use original date data, not processed
            subject_id <- if (!is.null(subjects)) subjects[i] else i

            if (day_is_na) {
              warning(sprintf("NA imputed for subject %s (date: %s)", subject_id, original_date), call. = FALSE)
            } else if (month_is_na) {
              warning(sprintf("NA imputed for subject %s (date: %s)", subject_id, original_date), call. = FALSE)
            }
          }
        }
      }

      # Restore NA values in the result
      if (is.list(fixed.dates)) {
        fixed.dates[na_indices] <- list(NULL)
      } else if (is.vector(fixed.dates)) {
        # Handle case where fixed.dates is a vector
        fixed.dates[na_indices] <- NA
      }
    }

    # Check if the result is an error condition from extendr
    if (inherits(fixed.dates, "extendr_error")) {
      # Extract the error message and throw it as a proper R error
      error_msg <- if ("value" %in% names(fixed.dates)) {
        fixed.dates$value
      } else {
        as.character(fixed.dates)
      }
      stop(error_msg, call. = FALSE)
    }

    # Convert to Date class, handling NULL values from Rust
    return(as.Date(sapply(fixed.dates, function(x) if (is.null(x)) NA_character_ else x)))
  }

  # Process columns either in parallel or sequentially
  if (cores > 1 && length(col.names) > 1) {
    # Check if required packages are available
    if (!requireNamespace("future", quietly = TRUE) || !requireNamespace("future.apply", quietly = TRUE)) {
      stop("Parallel processing requires 'future' and 'future.apply' packages. Install with: install.packages(c('future', 'future.apply'))")
    }

    # Determine optimal number of workers (minimum of cores and columns)
    n_workers <- min(cores, length(col.names))

    # Set up parallel plan
    future::plan(future::multisession, workers = n_workers)

    # Process columns in parallel
    result_columns <- future.apply::future_lapply(col.names, process_column)
    names(result_columns) <- col.names

    # Assign results back to dataframe
    for (i in seq_along(col.names)) {
      df[, col.names[i]] <- result_columns[[i]]
    }
  } else {
    # Process columns sequentially
    for (col.name in col.names) {
      df[, col.name] <- process_column(col.name)
    }
  }
  # Reset future plan to sequential after processing (closes workers)
  future::plan(future::sequential)

  df
}
