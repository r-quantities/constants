#' \pkg{constants}: Reference on Constants, Units and Uncertainty
#'
#' This package provides the 2022 version of the CODATA internationally recommended
#' values of the fundamental physical constants for their use within the \R language.
#'
#' @author Iñaki Ucar
#'
#' @references
#' Eite Tiesinga, Peter J. Mohr, David B. Newell, and Barry N. Taylor (2024).
#' The 2022 CODATA Recommended Values of the Fundamental Physical Constants
#' (Web Version 9.0). Database developed by J. Baker, M. Douma, and S. Kotochigova.
#' Available at https://physics.nist.gov/cuu/Constants/,
#' National Institute of Standards and Technology, Gaithersburg, MD 20899.
#'
#' @seealso \code{\link{codata}}, \code{\link{syms}}, \code{\link{lookup}}.
#'
#' @name constants-package
"_PACKAGE"

#' CODATA Recommended Values of the Fundamental Physical Constants: 2022
#'
#' The Committee on Data for Science and Technology (CODATA) is an interdisciplinary
#' committee of the International Council for Science. The Task Group on Fundamental
#' Constants periodically provides the internationally accepted set of values of
#' the fundamental physical constants. This dataset contains the "2022 CODATA"
#' version, published on May 2024.
#'
#' @format An object of class \code{data.frame} with the following information
#' for each physical constant:
#' ASCII \code{symbol}, \code{quantity} description, \code{type},
#' \code{value}, \code{uncertainty}, \code{unit}.
#'
#' @source
#' Eite Tiesinga, Peter J. Mohr, David B. Newell, and Barry N. Taylor (2024).
#' The 2022 CODATA Recommended Values of the Fundamental Physical Constants
#' (Web Version 9.0). Database developed by J. Baker, M. Douma, and S. Kotochigova.
#' Available at https://physics.nist.gov/cuu/Constants/,
#' National Institute of Standards and Technology, Gaithersburg, MD 20899.
#'
#' @seealso \code{\link{syms}}, \code{\link{lookup}}.
"codata"

#' @name codata
#' @format A \code{matrix} of correlations between physical constants.
"codata.cor"

#' Lists of Constants
#'
#' These named lists contain ready-to-use values for all the fundamental
#' physical constants.
#'
#' Experimental support for correlations between constants is provided via the
#' \pkg{errors} package, but it is disabled by default. To enable it, the
#' following option must be set before loading the package:
#'
#' \code{options(constants.correlations=TRUE)}
#'
#' Alternatively, \code{constants:::set_correlations()} may be used
#' interactively, but scripts should not rely on this non-exported function,
#' as it may disappear in future versions.
#'
#' @format
#' A \code{list}, where names correspond to symbols in \code{codata$symbol}.
#' \itemize{
#' \item \code{syms} contains plain numeric values.
#' \item \code{syms_with_errors} contains objects of type \code{errors}, which
#' enables automatic uncertainty propagation.
#' \item \code{syms_with_units} contains objects of type \code{units}, which
#' enables automatic conversion, derivation and simplification.
#' \item \code{syms_with_quantities} contains objects of type \code{quantities},
#' which combines \code{errors} and \code{units}.
#' }
#' The enriched versions of \code{syms} are available only if the corresponding
#' optional packages, \pkg{errors}, \pkg{units} and/or \pkg{quantities} are
#' installed. See the documentation of these packages for further information.
#'
#' @seealso \code{\link{codata}}, \code{\link{lookup}}.
#'
#' @examples
#' # the speed of light
#' syms$c0
#' # use the constants in a local environment
#' with(syms, c0)
#'
#' # attach only Planck-related constants
#' (lkp <- lookup("planck", ignore.case=TRUE))
#' idx <- as.integer(rownames(lkp))
#' attach(syms[idx])
#' h
#' plkl
#'
#' # the same with uncertainty
#' detach(syms[idx])
#' attach(syms_with_errors[idx])
#' h
#' plkl
#'
#' # the same with units
#' detach(syms_with_errors[idx])
#' attach(syms_with_units[idx])
#' h
#' plkl
#'
#' # the same with everything
#' detach(syms_with_units[idx])
#' attach(syms_with_quantities[idx])
#' h
#' plkl
#'
#' @export
syms <- NULL

#' @name syms
#' @format NULL
#' @export
syms_with_errors <- NULL

#' @name syms
#' @format NULL
#' @export
syms_with_units <- NULL

#' @name syms
#' @format NULL
#' @export
syms_with_quantities <- NULL

set_correlations <- function() {
  stopifnot(requireNamespace("errors", quietly = TRUE))

  n <- length(syms_with_errors)
  e.diag <- diag(constants::codata$uncertainty)
  codata.cov <- e.diag %*% constants::codata.cor %*% e.diag
  for (i in seq_len(n-1)) for (j in (i+1):n) {
    ijcov <- codata.cov[i, j]
    if (!ijcov) next
    errors::covar(syms_with_errors[[i]], syms_with_errors[[j]]) <- ijcov
  }
}

.onLoad <- function(libname, pkgname) {
  syms <<- as.list(constants::codata$value)
  names(syms) <<- as.vector(constants::codata$symbol)

  if (requireNamespace("errors", quietly = TRUE)) {
    syms_with_errors <<- Map(
      errors::set_errors, syms, constants::codata$uncertainty)

    if (getOption("constants.correlations", FALSE))
      set_correlations()
  }

  if (requireNamespace("units", quietly = TRUE)) {
    # define the speed of light
    if (utils::packageVersion("units") < "0.7-0") {
      try(getExportedValue("units", "remove_symbolic_unit")("c"), silent=TRUE)
      getExportedValue("units", "install_conversion_constant")("c", "m/s", syms$c0)
    } else {
      getExportedValue("units", "remove_unit")("c")
      getExportedValue("units", "install_unit")("c", paste(syms$c0, "m/s"))
    }

    syms_with_units <<- Map(
      units::set_units, syms, constants::codata$unit, mode="standard")
  }

  if (requireNamespace("quantities", quietly = TRUE)) {
    syms_with_quantities <<- Map(
      units::set_units, syms_with_errors, constants::codata$unit, mode="standard")
  }
}

.onAttach <- function(libname, pkgname) {
  if (!requireNamespace("errors", quietly = TRUE))
    packageStartupMessage(paste(
      "Package 'errors' not found.",
      "Constants with uncertainty ('syms_with_errors') not available."))
  if (!requireNamespace("units", quietly = TRUE))
    packageStartupMessage(paste(
      "Package 'units' not found.",
      "Constants with units ('syms_with_units') not available."))
  if (!requireNamespace("quantities", quietly = TRUE))
    packageStartupMessage(paste(
      "Package 'quantities' not found.",
      "Constants with uncertainty+units ('syms_with_quantities') not available."))
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
  ind <- do.call(c, lapply(
    cols, function(col) grep(pattern, constants::codata[[col]], ...)))
  constants::codata[sort(unique(ind)),]
}
