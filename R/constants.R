#' \pkg{constants}: Reference on Constants, Units and Uncertainty
#'
#' This package provides the 2018 version of the CODATA internationally recommended
#' values of the fundamental physical constants for their use within the \R language.
#'
#' @author Iñaki Ucar
#'
#' @references
#' Eite Tiesinga, Peter J. Mohr, David B. Newell, and Barry N. Taylor (2020).
#' The 2018 CODATA Recommended Values of the Fundamental Physical Constants
#' (Web Version 8.1). Database developed by J. Baker, M. Douma, and S. Kotochigova.
#' Available at http://physics.nist.gov/constants,
#' National Institute of Standards and Technology, Gaithersburg, MD 20899.
#'
#' @seealso \code{\link{codata}}, \code{\link{syms}}, \code{\link{lookup}}.
#'
#' @docType package
#' @name constants-package
NULL

#' CODATA Recommended Values of the Fundamental Physical Constants: 2018
#'
#' The Committee on Data for Science and Technology (CODATA) is an interdisciplinary
#' committee of the International Council for Science. The Task Group on Fundamental
#' Constants periodically provides the internationally accepted set of values of
#' the fundamental physical constants. This dataset contains the "2018 CODATA"
#' version, published on May 2019.
#'
#' @format \code{codata} is a data frame with ... cases (rows) and 6 variables
#' (columns) named \code{symbol}, \code{quantity}, \code{type}, \code{value},
#' \code{uncertainty}, \code{unit}.
#'
#' @source
#' Eite Tiesinga, Peter J. Mohr, David B. Newell, and Barry N. Taylor (2020).
#' The 2018 CODATA Recommended Values of the Fundamental Physical Constants
#' (Web Version 8.1). Database developed by J. Baker, M. Douma, and S. Kotochigova.
#' Available at http://physics.nist.gov/constants,
#' National Institute of Standards and Technology, Gaithersburg, MD 20899.
#'
#' @seealso \code{\link{syms}}, \code{\link{lookup}}.
"codata"

#' Lists Containing All Symbols.
#'
#' These lists contain the named values for all the fundamental physical constants.
#'
#' @format An object of class list or NULL (if not available).
#'
#' @details \code{syms} contains plain numeric values. \code{syms_with_errors} contains
#' objects of type \code{errors}, which encloses values with absolute errors and enables
#' automatic error propagation (only available if the \code{errors} package is installed;
#' see the documentation of that package for further information). \code{syms_with_units}
#' contains objects of type \code{units}, which encloses values with units and enables
#' automatic conversion, derivation and simplification (only available if the \code{units}
#' package is installed; see the documentation of that package for further information).
#'
#' @seealso \code{\link{codata}}, \code{\link{lookup}}.
#'
#' @examples
#' # the speed of light
#' with(syms, c0)
#'
#' # the Planck constant
#' attach(syms)
#' h
#'
#' detach(syms); attach(syms_with_errors)
#' h
#'
#' detach(syms_with_errors); attach(syms_with_units)
#' h
#'
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
      errors::errors(syms_with_errors[[i]]) <<- constants::codata$uncertainty[[i]]
  }

  if (requireNamespace("units", quietly = TRUE)) {
    # define the speed of light
    try(units::remove_symbolic_unit("c"), silent=TRUE)
    units::install_conversion_constant("c", "m/s", syms$c0)

    syms_with_units <<- syms
    for (i in seq_along(syms))
      units(syms_with_units[[i]]) <<- units::as_units(constants::codata$unit[[i]])
  }
}

.onAttach <- function(libname, pkgname) {
  if (!requireNamespace("errors", quietly = TRUE))
    packageStartupMessage(paste(
      "Package 'errors' not found.",
      "Constants with errors ('syms_with_errors') not available."))
  if (!requireNamespace("units", quietly = TRUE))
    packageStartupMessage(paste(
      "Package 'units' not found.",
      "Constants with units ('syms_with_units') not available."))
}

#' Lookup for Fundamental Physical Constants
#'
#' A simple wrapper around \code{\link{grep}} for exploring the CODATA dataset.
#'
#' @param pattern character string containing a regular expression to be matched
#' (see \code{\link{grep}}).
#' @param cols columns to perform pattern matching (see \code{\link{codata}}).
#' @param ... additional arguments for \code{\link{grep}}.
#'
#' @seealso \code{\link{codata}}, \code{\link{syms}}.
#'
#' @examples
#' lookup("planck", ignore.case=TRUE)
#'
#' @export
lookup <- function(pattern, cols=c("symbol", "quantity", "type"), ...) {
  cols <- match.arg(cols, several.ok = TRUE)
  ind <- do.call(c, lapply(cols, function(col) grep(pattern, constants::codata[[col]], ...)))
  constants::codata[sort(unique(ind)),]
}
