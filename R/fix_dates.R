months <- new.env()
months$abbrev <- tolower(month.abb)
months$full <- tolower(month.name)

#' @title Clean up messy date columns
#' @description Cleans up a \code{dataframe} object which has date columns
#' entered via a free-text box (possibly by different users) and are therefore
#' in a non-standardized format. Supports numerous separators including /,- or
#' space. Supports all-numeric, abbreviation or long-hand month notation. Where
#' day of the month has not been supplied, the first day of the month is
#' imputed. When day, month and year is given either DMY or YMD is assumed; the
#' US system of MDY is not supported.
#' @param df A \code{dataframe} object with messy date column(s)
#' @param col.names Character vector of names of columns of messy date data
#' @param id Name of column containing row IDs. By default, the first column is
#' assumed.
#' @param day.impute Integer. Day of the month to be imputed if not available.
#'   defaults to 1.
#' @param month.impute Integer. Month to be be imputed if not available.
#'   Defaults to 7 (July)
#' @return A \code{dataframe} object. Selected columns are of type \code{Date}
#' @seealso \link{fix_date} Similar to \code{fix_dates()} except can only be
#' applied to character obkects. 
#' @examples
#' bad.dates <- data.frame(id = seq(5),
#'                         some.dates = c("02/05/92",
#'                                        "01-04-2020",
#'                                        "1996/05/01",
#'                                        "2020-05-01",
#'                                        "02-04-96"),
#'                         some.more.dates = c("2015",
#'                                             "02/05/00",
#'                                             "05/1990",
#'                                             "2012-08",
#'                                             "jan 2020"))
#'fixed.df <- fix_dates(bad.dates, c("some.dates", "some.more.dates"))
#' @export
fix_dates <- function(df,
                      col.names,
                      day.impute = 1,
                      month.impute = 7,
                      id = NULL) {
  if (!is.data.frame(df)) {
    stop("df should be a dataframe object!")
  }
  if (any(!is.character(col.names))) {
    stop("col.names should be a character vector!")
  }
  
  if (is.null(id)) id <- 1 # Use first column as id if not explictly given

  .checkday(day.impute)
  .checkmonth(month.impute)
  day.impute <- .convertimpute(day.impute)
  month.impute <- .convertimpute(month.impute)
  error.status <- 0
  
  for (col.name in col.names) {
    fixed.dates <- c()
      for (i in 1:nrow(df)) {
        tryCatch(
          {
            fixed.dates[i] <- .fix_date(df[i, col.name],
                                       day.impute,
                                       month.impute,
                                       subject = df[i, id])
            },
          error = function(cond){
            message(paste0("Unable to resolve date for subject ",
                       df[i, id],
                       " (date: ",
                       df[i, col.name],
                       ")\n")
                 )
            stop(cond)}
        )
      }
    df[, col.name] <- as.Date(fixed.dates)
    }
    df
}

.fix_date <- function(date, day.impute, month.impute, subject) {

  if (is.null(date) || is.na(date) || as.character(date) == "") {
    return(NA)
  }
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
    warning(paste0("NA imputed for subject ",
                   subject,
                   " (date: ",
                   date,
                   ")\n"),
            call. = FALSE)
  } else { 
    fixed_date <- paste0(year, "-", month, "-", day)
  }
  fixed_date
}

.separate_date <- function(date) {
  if (grepl("/", date, fixed = TRUE)) {
    date_vec <- stringr::str_split_fixed(date,
                                         pattern = "/",
                                         n = Inf)
  } else if (grepl("-", date, fixed = TRUE)) {
    date_vec <- stringr::str_split_fixed(date,
                                         pattern = "-",
                                         n = Inf)
  } else if (grepl(" ", date, fixed = TRUE)) {
    date_vec <- stringr::str_split_fixed(date,
                                         pattern = " ",
                                         n = Inf)
  }
  date_vec
}

.convert_text_month <- function(date) {
  date <- tolower(date)
  for (i in 1:12) {
    if (i < 10) {
      replacement <- paste0("0", i)
    } else {
      replacement <- i
    }
    date <- gsub(pattern = months$full[i],
                 replacement = replacement,
                 x = date)
    
    date <- gsub(pattern = months$abbrev[i],
                 replacement = replacement,
                 x = date)
  }
  date
}

.checkday <- function(day.impute){
  if (!is.na(day.impute) && !is.null(day.impute)) {
    if (day.impute < 1 | day.impute > 28) {
      stop("day.impute should be an integer between 1 and 28\n")
    }
    if (!(day.impute %% 1 == 0)) {
      stop("day.impute should be an integer\n")
    }
  }
  return()
}

.checkmonth <- function(month.impute){
  if (!is.na(month.impute) && !is.null(month.impute)) {
    if (month.impute < 1 | month.impute > 12) {
      stop("month.impute should be an integer between 1 and 12\n")
    }
    if (!(month.impute %% 1 == 0)) {
      stop("month.impute should be an integer\n")
    }
  }
  return()
}

.checkoutput <- function(day, month){
  if (!is.na(month)) {
    if (as.numeric(month) > 12 | as.numeric(month) < 1) {
      stop("Month not in expected range \n")
    }
  }
  if (!is.na(day)) {
    if (as.numeric(day) > 31 | as.numeric(day) < 1) {
      stop("Day of the year not in expected range \n")
    }
  }
  NULL
}

.convertimpute <- function(impute){
  if (!is.na(impute) && !is.null(impute)) {
    if (impute < 10) {
      replacement <- paste0("0", impute)
    } else {
      replacement <- as.character(impute)
    }
  } else {
    replacement <- impute
  }
  replacement
}

.imputemonth <- function(month.impute){
  if (is.null(month.impute)) {
    stop("Missing month with no imputation value given \n")
  } else {
    month.impute
  }
}

.imputeday <- function(day.impute){
  if (is.null(day.impute)) {
    stop("Missing day with no imputation value given \n")
  } else {
    day.impute
  }
}
