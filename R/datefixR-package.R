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
#' @section Author:
#' \strong{Maintainer}: Nathan Constantine-Cooke
#' \email{nathan.constantine-cooke@@ed.ac.uk}
#' \href{https://orcid.org/0000-0002-4437-8713}{(ORCID)}
#'
#' Other contributors:
#'  * Jonathan Kitt `[`contributor, translator`]`
#'  * Antonio J. Pérez-Luque  \href{https://orcid.org/0000-0002-1747-0469}{(ORCID)} `[`contributor, translator`]`
#'  * Daniel Possenriede \href{https://orcid.org/0000-0002-6738-9845}{(ORCID)} `[`contributor, translator`]`
#'  * Anatoly Tsyplenkov \href{https://orcid.org/0000-0003-4144-8402}{(ORCID)} `[`contributor, translator`]`
#'  * Kaique dos S. Alves \href{https://orcid.org/0000-0001-9187-0252}{(ORCID)} `[`reviewer`]`
#'  * Al-Ahmadgaid B. Asaad  \href{https://orcid.org/0000-0003-3784-8593}{(ORCID)} `[`reviewer`]`
#'
#' @seealso
#' Useful links:
#' * \url{https://docs.ropensci.org/datefixR/}
#' * \url{https://github.com/ropensci/datefixR/}
#' * Report bugs at \url{https://github.com/ropensci/datefixR/issues}
## usethis namespace: start
#' @importFrom lifecycle deprecated
#' @importFrom Rcpp sourceCpp
#' @useDynLib datefixR, .registration = TRUE
## usethis namespace: end
#' @docType package
#' @name datefixR
NULL
