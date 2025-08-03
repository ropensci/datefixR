#' datefixR: Standardize Dates in Different Formats or with Missing Data
#'
#' @description There are many different formats dates are commonly represented
#'   with: the order of day, month, or year can differ, different separators
#'   ("-", "/", or whitespace) can be used, months can be numerical, names, or
#'   abbreviations and year given as two digits or four. `datefixR` takes dates
#'   in all these different formats and converts them to \R{}'s built-in date
#'   class. If `datefixR` cannot standardize a date, such as because it is too
#'   malformed, then the user is told which date cannot be standardized and the
#'   corresponding ID for the row. `datefixR` also allows the imputation of
#'   missing days and months with user-controlled behavior.
#'
#'   Get started by reading \code{vignette("datefixR")}
#'
#' @seealso
#' Useful links:
#' * \url{https://docs.ropensci.org/datefixR/}
#' * \url{https://github.com/ropensci/datefixR/}
#' * Report bugs at \url{https://github.com/ropensci/datefixR/issues}
## usethis namespace: start
#' @importFrom lifecycle deprecated
#' @useDynLib datefixR, .registration = TRUE
## usethis namespace: end
#' @docType package
#' @name datefixR
#' @keywords internal
"_PACKAGE"
