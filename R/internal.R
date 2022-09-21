
#' @noRd
.fix_date <- function(date,
                      day.impute,
                      month.impute,
                      subject,
                      format = format) {
  if (is.null(date) || is.na(date) || as.character(date) == "") {
    return(NA)
  }

  date <- as.character(date) |>
    .rm_ordinal_suffixes() |>
    .process_french()

  if (nchar(date) == 4) {
    # Just given year
    year <- date
    month <- .imputemonth(month.impute)
    day <- .imputeday(day.impute)
  } else {
    if (tolower(.separate_date(date)[1]) %in% unlist(months$months)) {
      format <- "mdy"
    }
    date <- .convert_text_month(date)
    date_vec <- .separate_date(date)
    if (any(nchar(date_vec) > 4)) {
      stop("unable to tidy a date")
    }
    date_vec <- .appendyear(date_vec)

    if (length(date_vec) < 3) {
      # ASSUME MM/YYYY, YYYY/MM
      day <- .imputeday(day.impute)
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
  .checkoutput(day, month)
  .combinepartialdate(day, month, year, date, subject)
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
.checkday <- function(day.impute) {
  if (!is.na(day.impute) && !is.null(day.impute)) {
    if (day.impute < 1 || day.impute > 28) {
      stop("day.impute should be an integer between 1 and 28\n")
    }
    if (!(day.impute %% 1 == 0)) {
      stop("day.impute should be an integer\n")
    }
  }
  return()
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
.checkoutput <- function(day, month) {
  if (!is.na(month)) {
    if (as.numeric(month) > 12 || as.numeric(month) < 1) {
      stop("Month not in expected range \n")
    }
  }
  if (!is.na(day)) {
    if (as.numeric(day) > 31 || as.numeric(day) < 1) {
      stop("Day of the year not in expected range \n")
    }
  }
  NULL
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
.imputemonth <- function(month.impute) {
  if (is.null(month.impute)) {
    stop("Missing month with no imputation value given \n")
  } else {
    month.impute
  }
}

#' @noRd
.imputeday <- function(day.impute) {
  if (is.null(day.impute)) {
    stop("Missing day with no imputation value given \n")
  } else {
    day.impute
  }
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
      warning(paste0(
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
  if (all(nchar(date_vec) == 2)) {
    if (length(date_vec) == 3) {
      # Assume DD/MM/YY or MM/DD/YY
      date_vec[3] <- .yearprefix(date_vec[3])
    } else if (length(date_vec) == 2) {
      # Assume MM/YY
      date_vec[2] <- .yearprefix(date_vec[2])
    }
  }
  date_vec
}

#' @noRd
.fix_date_char <- function(date, day.impute = 1,
                           month.impute = 7,
                           format = "dmy") {
  if (is.null(date) || is.na(date) || as.character(date) == "") {
    return(NA)
  }
  if (!is.character(date)) stop("date should be a character \n")

  day.impute <- .convertimpute(day.impute)
  month.impute <- .convertimpute(month.impute)

  date <- as.character(date) |>
    .rm_ordinal_suffixes() |>
    .process_french()

  if (nchar(date) == 4) {
    # Just given year
    year <- date
    month <- .imputemonth(month.impute)
    day <- .imputeday(day.impute)
  } else {
    if (tolower(.separate_date(date)[1]) %in% unlist(months$months)) {
      format <- "mdy"
    }
    date <- .convert_text_month(date)
    date_vec <- .separate_date(date)
    if (any(nchar(date_vec) > 4)) {
      stop("unable to tidy a date")
    }
    date_vec <- .appendyear(date_vec)
    if (length(date_vec) < 3) {
      # ASSUME MM/YYYY, YYYY/MM
      day <- .imputeday(day.impute)
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
  .checkoutput(day, month)
  as.Date(.combinepartialdate(day, month, year, date))
}

#' @noRd
.process_french <- function(date) {
  date <- gsub(
    pattern = "le ",
    replacement = "",
    x = date,
    ignore.case = TRUE
  )
  gsub(
    pattern = "1er",
    replacement = "01",
    x = date,
    ignore.case = TRUE
  )
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
