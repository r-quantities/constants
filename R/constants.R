#' \pkg{constants}: Reference on Constants, Units and Uncertainty
#'
#' This package provides the 2014 version of the CODATA internationally recommended
#' values of the fundamental physical constants for their use within the \R language.
#'
#' @author Iñaki Ucar
#'
#' @references Mohr, P. J., Newell, D. B. and Taylor, B. N. (2016). CODATA recommended
#' values of the fundamental physical constants: 2014. \emph{Rev. Mod. Phys.},
#' 88, 035009. \doi{10.1103/RevModPhys.88.035009}.
#'
#' Mohr, P. J., Newell, D. B. and Taylor, B. N. (2016). CODATA recommended values
#' of the fundamental physical constants: 2014. \emph{J. Phys. Chem. Ref. Data},
#' 45, 043102. \doi{10.1063/1.4954402}.
#'
#' @seealso \code{\link{codata}}, \code{\link{syms}}, \code{\link{lookup}}.
#'
#' @docType package
#' @name constants
NULL

#' CODATA Recommended Values of the Fundamental Physical Constants: 2014
#'
#' The Committee on Data for Science and Technology (CODATA) is an interdisciplinary
#' committee of the International Council for Science. The Task Group on Fundamental
#' Constants periodically provides the internationally accepted set of values of
#' the fundamental physical constants. This dataset contains the "2014 CODATA"
#' version, published on 25 June 2015.
#'
#' @format \code{codata} is a data frame with ... cases (rows) and 6 variables (columns)
#' named \code{quantity}, \code{symbol}, \code{value}, \code{unit}, \code{rel_uncertainty},
#' and \code{type}.
#'
#' @source Mohr, P. J., Newell, D. B. and Taylor, B. N. (2016). CODATA recommended
#' values of the fundamental physical constants: 2014. \emph{Rev. Mod. Phys.},
#' 88, 035009. \doi{10.1103/RevModPhys.88.035009}.
#'
#' Mohr, P. J., Newell, D. B. and Taylor, B. N. (2016). CODATA recommended values
#' of the fundamental physical constants: 2014. \emph{J. Phys. Chem. Ref. Data},
#' 45, 043102. \doi{10.1063/1.4954402}.
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
#' hbar
#'
#' detach(syms); attach(syms_with_errors)
#' hbar
#'
#' detach(syms_with_errors); attach(syms_with_units)
#' hbar
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
      errors::errors(syms_with_errors[[i]]) <<- syms[[i]] * constants::codata$rel_uncertainty[[i]]
  }

  if (requireNamespace("units", quietly = TRUE)) {
    syms_with_units <<- syms
    for (i in seq_along(syms))
      units(syms_with_units[[i]]) <<- units::parse_unit(constants::codata$unit[[i]])
  }
}

.onAttach <- function(libname, pkgname) {
  if (!requireNamespace("errors", quietly = TRUE))
    packageStartupMessage("Package 'errors' not found. Constants with errors ('syms_with_errors') not available.")
  if (!requireNamespace("units", quietly = TRUE))
    packageStartupMessage("Package 'units' not found. Constants with units ('syms_with_units') not available.")
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
lookup <- function(pattern, cols=c("quantity", "symbol", "type"), ...) {
  cols <- match.arg(cols, several.ok = TRUE)
  ind <- do.call(c, lapply(cols, function(col) grep(pattern, constants::codata[[col]], ...)))
  constants::codata[sort(unique(ind)),]
}
