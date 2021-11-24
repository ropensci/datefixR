#' @title Convert improperly formatted date to R's Date class 
#' @description Converts a single improperly formatted date to R's Date class
#' Supports numerous separators including /,- or white space.
#' Supports all-numeric, abbreviation or long-hand month notation. Where
#' day of the month has not been supplied, the first day of the month is
#' imputed. When day, month and year is given either DMY or YMD is assumed; the
#' US system of MDY is not supported.
#' @param date Character to be converted to R's date class. 
#' @param day.impute Integer. Day of the month to be imputed if not available.
#'   defaults to 1.
#' @param month.impute Integer. Month to be be imputed if not available.
#'   Defaults to 7 (July)
#' @return An object belonging to R's built in \code{Date} class. 
#' @seealso \link{fix_dates} Similar to \code{fix_date()} except is applicable 
#' to columns of a dataframe.
#' @examples
#' bad.date <- "02 03 2021"
#' fixed.date <- fix_date(bad.date)
#' @export
fix_date <- function(date, day.impute = 1, month.impute = 7) {
  
  
  if (is.null(date) || is.na(date) || as.character(date) == "") {
    return(NA)
  }
  
  if (!is.character(date)) stop("date should be a character \n")
  
  .checkday(day.impute)
  .checkmonth(month.impute)
  day.impute <- .convertimpute(day.impute)
  month.impute <- .convertimpute(month.impute)
  
  date <- as.character(date)
  date <- .convert_text_month(date)
  
  if (nchar(date) == 4) {
    # Just given year
    year <- date
    month <- .imputemonth(month.impute)
    day <- .imputeday(day.impute)
  } else{
    date_vec <- .separate_date(date)
    if (any(nchar(date_vec) > 4)) {
      stop("unable to tidy a date")
    }
    if (all(nchar(date_vec) == 2)) {
      if (length(date_vec) == 3) {
        # Assume DD/MM/YY
        if (substr(date_vec[3], 1, 1)  == "0" || (
          substr(date_vec[3], 1, 1) == "1") || (
            substr(date_vec[3], 1, 1) == "2")) {
          date_vec[3] <- paste0("20", date_vec[3])
        } else{
          date_vec[3] <-  paste0("19", date_vec[3])
        }
      } else if (length(date_vec) == 2) {
        # Assume MM/YY
        if (substr(date_vec[2], 1, 1)  == "0" || (
          substr(date_vec[2], 1, 1) == "1") || (
            substr(date_vec[2], 1, 1) == "2")) {
          date_vec[2] <- paste0("20", date_vec[2])
        } else{
          date_vec[2] <-  paste0("19", date_vec[2])
        }
      }
    }
    if (length(date_vec) < 3) {
      # ASSUME MM/YYYY, YYYY/MM
      day <- .imputeday(day.impute) 
      if (nchar(date_vec[1]) == 4) {
        # Assume YYYY/MM
        year <- date_vec[1]; month <- date_vec[2]
      } else if (nchar(date_vec[2]) == 4) {
        year <- date_vec[2]; month <- date_vec[1]
      }
    } else{
      if (nchar(date_vec[1]) == 4) {
        # Assume YYYY/MM/DD
        year <- date_vec[1]; month <- date_vec[2]; day <- date_vec[3]
      } else{
        # Assume DD/MM/YYYY
        year <- date_vec[3]; month <- date_vec[2]; day <- date_vec[1]
      }
    }
  }
  .checkoutput(day, month)
  
  if (is.na(day) || is.na(month)) {
    fixed_date <- NA
    warning(paste0("NA imputed \n"),
            call. = FALSE)
  } else { 
    fixed_date <- paste0(year, "-", month, "-", day)
  }
  as.Date(fixed_date)
}