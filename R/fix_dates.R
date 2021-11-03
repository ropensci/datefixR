months <- new.env()
months$abbrev <- tolower(month.abb)
months$full <- tolower(month.name)

#' @title Clean up messy date columns
#' @description Cleans up a \code{dataframe} object which has date columns
#' entered via a free-text box (possibly by different users) and are therefore
#' in a non-standardised format. Supports numerous seperators including /,- or
#' space. Supports all-numeric, abbreviation or long-hand month notation. Where
#' day of the month has not been supplied, the first day of the month is
#' imputed. When day, month and year is given either DMY or YMD is assumed; the
#' US system of MDY is not supported.
#' @param df A \code{dataframe} object with messy date column(s)
#' @param col.names Character vector of names of columns of messy date data
#' @return A \code{dataframe} object. Selected columns are of type \code{Date}
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
fix_dates <- function(df, col.names) {
  if (!is.data.frame(df)) {
    stop("df should be a dataframe object!")
  }
  if (any(!is.character(col.names))) {
    stop("col.names should be a character vector!")
  }


  for (col.name in col.names) {
    fixed.dates <- c()
      for (i in 1:nrow(df)) {
        fixed.dates[i] <- fix_date(df[i, col.name])
      }
    df[, col.name] <- as.Date(fixed.dates)
    }
    df
}

fix_date <- function(date) {

  if (is.null(date) || is.na(date) || as.character(date) == "") {
    return(NA)
  }
  date <- as.character(date)
  date <- convert_text_month(date)

  if (nchar(date) == 4) {
    # Just given year
    year <- date; month <- "01"; day <- "01"
  } else{
    date_vec <- seperate_date(date)
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
      day <- "01"
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
  fixed_date <- paste0(year, "-", month, "-", day)
  fixed_date
}

seperate_date <- function(date) {
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

convert_text_month <- function(date) {
  date <- tolower(date)
  for (i in 1:12) {
    if (i < 10) {
      replacement <- paste0("0", i)
    } else {
      replacement <- i
    }
    date <- gsub(pattern = months$abbrev[i],
                 replacement = replacement,
                 x = date)
    date <- gsub(pattern = months$full[i],
                 replacement = replacement,
                 x = date)
  }
  date
}
