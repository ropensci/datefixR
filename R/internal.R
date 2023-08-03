#' @noRd
.fix_date <- function(date,
                      day.impute,
                      month.impute,
                      subject,
                      format = format,
                      excel,
                      roman.numeral) {
  if (is.null(date) || is.na(date) || as.character(date) == "") {
    return(NA)
  }

  date <- as.character(date) |>
    .rm_ordinal_suffixes() |>
    process_french() |>
    process_russian()

  if (nchar(date) == 4) {
    # Just given year
    year <- date
    imputemonth(month.impute)
    month <- as.character(month.impute)
    imputeday(day.impute)
    day <- day.impute
  } else {
    if (!grepl("\\D", date)) {
      # Assume date is number of days since 1970-01-01
      if (excel) {
        return(as.character(as.Date(as.numeric(date), origin = "1900-01-01")))
      } else {
        return(as.character(as.Date(as.numeric(date), origin = "1970-01-01")))
      }
    }

    if (tolower(.separate_date(date)[1]) %in% unlist(months$months)) {
      format <- "mdy"
    }
    date <- .convert_text_month(date)
    date_vec <- .separate_date(date)

    if (roman.numeral) date_vec <- roman_conversion(date_vec)

    if (any(nchar(date_vec) > 4)) {
      stop("unable to tidy a date")
    }
    date_vec <- .appendyear(date_vec)

    if (length(date_vec) < 3) {
      # ASSUME MM/YYYY, YYYY/MM
      imputeday(day.impute)
      day <- day.impute
      if (nchar(date_vec[1]) == 4) {
        # Assume YYYY/MM
        year <- date_vec[1]
        month <- date_vec[2]
      } else if (nchar(date_vec[2]) == 4) {
        year <- date_vec[2]
        month <- date_vec[1]
      }
    } else {
      if (nchar(date_vec[1]) == 4) {
        # Assume YYYY/MM/DD
        year <- date_vec[1]
        month <- date_vec[2]
        day <- date_vec[3]
      } else {
        if (format == "dmy") {
          # Assume DD/MM/YYYY
          year <- date_vec[3]
          month <- date_vec[2]
          day <- date_vec[1]
        }
        if (format == "mdy") {
          year <- date_vec[3]
          month <- date_vec[1]
          day <- date_vec[2]
        }
      }
    }
  }
  output <- .checkoutput(day, month, year)
  .combinepartialdate(output$day, output$month, output$year, date, subject)
}

#' @noRd
.separate_date <- function(date) {
  if (grepl("/", date, fixed = TRUE)) {
    date_vec <- stringr::str_split_fixed(date,
      pattern = "/",
      n = Inf
    )
  } else if (grepl("-", date, fixed = TRUE)) {
    date_vec <- stringr::str_split_fixed(date,
      pattern = "-",
      n = Inf
    )
  } else if (grepl(" de ", date, fixed = TRUE)) {
    # Spanish date
    date_vec <- stringr::str_split_fixed(date,
      pattern = " de | del ",
      n = Inf
    )
  } else if (grepl(".", date, fixed = TRUE)) {
    # German date
    date_vec <- stringr::str_split_fixed(date,
      pattern = "\\.(\\s)|\\.'|\\.|(\\s)'|(\\s)",
      n = Inf
    )
  } else if (grepl(" ", date, fixed = TRUE)) {
    date_vec <- stringr::str_split_fixed(date,
      pattern = " ",
      n = Inf
    )
  }
  date_vec
}

#' @noRd
.convert_text_month <- function(date) {
  date <- tolower(date)

  for (i in 1:12) {
    if (i < 10) {
      replacement <- paste0("0", i)
    } else {
      replacement <- i
    }
    for (j in seq_along(months$months[[i]])) {
      date <- gsub(
        pattern = months$months[[i]][j],
        replacement = replacement,
        x = date
      )
    }
  }
  date
}

#' @noRd
.checkmonth <- function(month.impute) {
  if (!is.na(month.impute) && !is.null(month.impute)) {
    if (month.impute < 1 || month.impute > 12) {
      stop("month.impute should be an integer between 1 and 12\n")
    }
    if (!(month.impute %% 1 == 0)) {
      stop("month.impute should be an integer\n")
    }
  }
  return()
}

#' @noRd
.checkoutput <- function(day, month, year) {
  day <- as.numeric(day)
  month <- as.numeric(month)
  year <- as.numeric(year)

  if (!is.na(month)) {
    if (month > 12 | month < 1) {
      stop("Month not in expected range \n")
    }
  }

  days.month <- months$days # vector of days in each month on non-leap year
  # leap year check

  if (!is.na(day) & !is.na(month) & !is.na(year)) {
    if (month == 2) {
      if ((year %% 4) == 0) {
        if (((year %% 100) == 0) & ((year %% 400) == 0)) {
          days.month[2] <- 29
        }
        if (!(year %% 100 == 0)) {
          days.month[2] <- 29
        }
      }
    }

    if (day > 31) stop("Day not in expected range\n")
    if (day > days.month[month]) {
      day <- days.month[month]
    }
  }
  list(day = day, month = month, year = year)
}

#' @noRd
.checkformat <- function(format) {
  if (!(format %in% c("dmy", "mdy"))) {
    stop("format should be either 'dmy' or 'mdy' \n")
  }
}

#' @noRd
.convertimpute <- function(impute) {
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


#' @noRd
.yearprefix <- function(year) {
  if (substr(year, 1, 1) %in% 0:as.numeric(substr(Sys.Date(), 3, 3))) {
    year <- paste0("20", year)
  } else {
    year <- paste0("19", year)
  }
  year
}

#' @noRd
.combinepartialdate <- function(day, month, year, date = NULL, subject = NULL) {
  if (is.na(day) || is.na(month)) {
    fixed_date <- NA
    if (is.null(subject)) {
      warning("NA imputed (date: ",
        date,
        ")\n",
        call. = FALSE
      )
    } else {
      warning(
        paste0(
          "NA imputed for subject ",
          subject,
          " (date: ",
          date,
          ")\n"
        ),
        call. = FALSE
      )
    }
  } else {
    fixed_date <- paste0(year, "-", month, "-", day)
  }
  fixed_date
}

#' @noRd
.appendyear <- function(date_vec) {
  if (all(nchar(date_vec) == 2 | nchar(date_vec) == 1)) {
    if (length(date_vec) == 3) {
      if (nchar(date_vec[3]) == 2) date_vec[3] <- .yearprefix(date_vec[3])
    } else if (length(date_vec) == 2) {
      # Assume MM/YY
      if (nchar(date_vec[2]) == 2) date_vec[2] <- .yearprefix(date_vec[2])
    }
  }
  date_vec
}

#' @noRd
.fix_date_char <- function(date, day.impute = 1,
                           month.impute = 7,
                           format = "dmy",
                           excel,
                           roman.numeral) {
  if (is.null(date) || is.na(date) || as.character(date) == "") {
    return(NA)
  }
  if (!is.character(date)) stop("date should be a character \n")

  day.impute <- .convertimpute(day.impute)
  month.impute <- .convertimpute(month.impute)

  date <- as.character(date) |>
    .rm_ordinal_suffixes() |>
    process_french() |>
    process_russian()

  if (nchar(date) == 4) {
    # Just given year
    year <- date
    imputemonth(month.impute)
    month <- as.character(month.impute)
    imputeday(day.impute)
    day <- day.impute
  } else {
    if (!grepl("\\D", date)) {
      if (excel) {
        # Excel incorrectly considers 1900 to be a leap year
        return(as.Date(as.numeric(date) - 2, origin = "1900-01-01"))
      } else {
        return(as.Date(as.numeric(date), origin = "1970-01-01"))
      }
    }
    if (tolower(.separate_date(date)[1]) %in% unlist(months$months)) {
      format <- "mdy"
    }
    date <- .convert_text_month(date)
    date_vec <- .separate_date(date)
    if (roman.numeral) date_vec <- roman_conversion(date_vec)
    if (any(nchar(date_vec) > 4)) {
      stop("unable to tidy a date")
    }
    date_vec <- .appendyear(date_vec)
    if (length(date_vec) < 3) {
      # ASSUME MM/YYYY, YYYY/MM
      imputeday(day.impute)
      day <- day.impute
      if (nchar(date_vec[1]) == 4) {
        # Assume YYYY/MM
        year <- date_vec[1]
        month <- date_vec[2]
      } else if (nchar(date_vec[2]) == 4) {
        year <- date_vec[2]
        month <- date_vec[1]
      }
    } else {
      if (nchar(date_vec[1]) == 4) {
        # Assume YYYY/MM/DD
        year <- date_vec[1]
        month <- date_vec[2]
        day <- date_vec[3]
      } else {
        if (format == "dmy") {
          # Assume DD/MM/YYYY
          year <- date_vec[3]
          month <- date_vec[2]
          day <- date_vec[1]
        }
        if (format == "mdy") {
          year <- date_vec[3]
          month <- date_vec[1]
          day <- date_vec[2]
        }
      }
    }
  }
  output <- .checkoutput(day, month, year)
  as.Date(.combinepartialdate(output$day, output$month, output$year, date))
}

#' @noRd
.rm_ordinal_suffixes <- function(date) {
  # Remove ordinal suffixes
  stringr::str_replace(date, "(\\d)(st,)", "\\1") |>
    stringr::str_replace("(\\d)(nd,)", "\\1") |>
    stringr::str_replace("(\\d)(rd,)", "\\1") |>
    stringr::str_replace("(\\d)(th,)", "\\1") |>
    stringr::str_replace("(\\d)(st)", "\\1") |>
    stringr::str_replace("(\\d)(nd)", "\\1") |>
    stringr::str_replace("(\\d)(rd)", "\\1") |>
    stringr::str_replace("(\\d)(th)", "\\1")
}

roman_conversion <- function(date_vec) {
  if (date_vec[2] %in% months$roman) {
    date_vec[2] <- which(months$roman == date_vec[2])
    if (nchar(date_vec[2]) == 1) {
      date_vec[2] <- paste0("0", date_vec[2])
    }
  }
  date_vec
}
