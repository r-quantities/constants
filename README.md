
<!-- README.md is generated from README.Rmd. Please edit that file -->
constants: Reference on Constants, Units and Uncertainty
========================================================

[![Build Status](https://travis-ci.org/Enchufa2/constants.svg?branch=master)](https://travis-ci.org/Enchufa2/constants) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/constants)](https://cran.r-project.org/package=constants) [![Downloads](http://cranlogs.r-pkg.org/badges/constants)](https://cran.r-project.org/package=constants)

The **constants** package provides the 2014 version of the CODATA internationally recommended values of the fundamental physical constants for their use within the R language.

Installation
------------

The installation from GitHub requires the [devtools](https://github.com/hadley/devtools) package.

``` r
# install.packages("devtools")
devtools::install_github("Enchufa2/constants")
```

Example
-------

``` r
library(constants)

# use the constants in a local environment
with(syms, c0)
#> [1] 299792458

# explore which constants are available
lookup("planck", ignore.case=TRUE)
#>           quantity  symbol           value unit rel_uncertainty      type
#> 7  Planck constant       h 6.626070040e-34  J s         1.2e-08 universal
#> 8  Planck constant    h_eV 4.135667662e-15 eV s         6.1e-09 universal
#> 9  Planck constant    hbar        h/(2*pi)  J s         1.2e-08 universal
#> 10 Planck constant hbar_eV     h_eV/(2*pi) eV s         6.1e-09 universal

# attach the symbols to the search path and use them explicitly
attach(syms)
hbar
#> [1] 1.054572e-34

# use constants with errors
detach(syms); attach(syms_with_errors)
hbar
#> 1.05457180(1)e-34

# use constants with units
detach(syms_with_errors); attach(syms_with_units)
hbar
#> 1.054572e-34 J*s

# the whole dataset
head(codata)
#>                             quantity    symbol        value        unit
#> 1           speed of light in vacuum        c0    299792458       m s-1
#> 2                  magnetic constant       mu0    4*pi*1e-7       N A-2
#> 3                  electric constant  epsilon0 1/(mu0*c0^2)       F m-1
#> 4 characteristic impedance of vacuum        Z0       mu0*c0           Ω
#> 5  Newtonian constant of gravitation         G  6.67408e-11 m3 kg-1 s-2
#> 6  Newtonian constant of gravitation G/hbar*c0  6.70861e-39    GeV-2 c4
#>   rel_uncertainty      type
#> 1         0.0e+00 universal
#> 2         0.0e+00 universal
#> 3         0.0e+00 universal
#> 4         0.0e+00 universal
#> 5         4.7e-05 universal
#> 6         4.7e-05 universal
```
