#' \pkg{constants}: Reference on Constants, Units and Uncertainty
#'
#' CODATA internationally recommended 2014 values of the fundamental physical constants.
#'
#' @author Iñaki Ucar
#'
#' @docType package
#' @name constants
NULL

#' Lists containing all symbols.
#'
#' Lazy loaded when used
#' @export
syms <- list()

#' @rdname syms
#' @export
syms_with_errors <- NULL

#' @rdname syms
#' @export
syms_with_units <- NULL

.onLoad <- function(libname, pkgname) {
  syms <<- as.list(constants::codata$value)
  names(syms) <<- constants::codata$symbol
  for (i in seq_along(syms))
    syms[[i]] <<- eval(parse(text=syms[[i]]), envir = syms)

  if (requireNamespace("errors", quietly = TRUE)) {
    syms_with_errors <<- syms
    for (i in seq_along(syms))
      errors::errors(syms_with_errors[[i]]) <<- syms[[i]] * constants::codata$rel_uncertainty[[i]]
  } else packageStartupMessage("Package 'errors' not found. Constants with errors ('syms_with_errors') not available.")

  if (requireNamespace("units", quietly = TRUE)) {
    syms_with_units <<- syms
    for (i in seq_along(syms))
      units(syms_with_units[[i]]) <<- units::parse_unit(constants::codata$unit[[i]])
  } else packageStartupMessage("Package 'units' not found. Constants with units ('syms_with_units') not available.")
}
