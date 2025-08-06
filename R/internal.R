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
.checkformat <- function(format) {
  if (!(format %in% c("dmy", "mdy"))) {
    stop("format should be either 'dmy' or 'mdy' \n")
  }
}
