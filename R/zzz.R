.onAttach <- function(libname, pkgname) {
  multi.byte <- l10n_info()$MBCS
  if (!multi.byte) {
    packageStartupMessage(
      "The current locale does not support multibyte characters. ",
      "You may run into difficulties if any months are given as ",
      "non-English language names. \n"
    )
  }
}
