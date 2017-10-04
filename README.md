
<!-- README.md is generated from README.Rmd. Please edit that file -->
constants: Reference on Constants, Units and Uncertainty
========================================================

[![Build Status](https://travis-ci.org/r-quantities/constants.svg?branch=master)](https://travis-ci.org/r-quantities/constants) [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/constants)](https://cran.r-project.org/package=constants) [![Downloads](https://cranlogs.r-pkg.org/badges/constants)](https://cran.r-project.org/package=constants)

The **constants** package provides the CODATA internationally recommended values of the fundamental physical constants, provided as symbols for direct use within the R language. Optionally, the values with errors and/or the values with units are also provided if the 'errors' and/or the 'units' packages are installed. The Committee on Data for Science and Technology (CODATA) is an interdisciplinary committee of the International Council for Science which periodically provides the internationally accepted set of values of the fundamental physical constants. This package contains the "2014 CODATA" version, published on 25 June 2015: Mohr, P. J., Newell, D. B. and Taylor, B. N. (2016), DOI: [10.1103/RevModPhys.88.035009](http://doi.org/10.1103/RevModPhys.88.035009), [10.1063/1.4954402](http://doi.org/10.1063/1.4954402).

Installation
------------

Install the release version from CRAN:

``` r
install.packages("constants")
```

The installation from GitHub requires the [remotes](https://cran.r-project.org/package=remotes) package.

``` r
# install.packages("remotes")
remotes::install_github("r-quantities/constants")
```

Example
-------

``` r
library(constants)

# use the constants in a local environment
with(syms, c0)
#> [1] 299792458

# explore which constants are available
lookup("planck constant", ignore.case=TRUE)
#>                  quantity  symbol            value      unit
#> 7         Planck constant       h  6.626070040e-34       J s
#> 8         Planck constant    h_eV  4.135667662e-15      eV s
#> 9         Planck constant    hbar         h/(2*pi)       J s
#> 10        Planck constant hbar_eV      h_eV/(2*pi)      eV s
#> 11        Planck constant hbar.c0      197.3269788    MeV fm
#> 212 molar Planck constant    Na.h 3.9903127110e-10 J s mol-1
#> 213 molar Planck constant Na.h.c0   0.119626565582 J m mol-1
#>     rel_uncertainty            type
#> 7           1.2e-08       universal
#> 8           6.1e-09       universal
#> 9           1.2e-08       universal
#> 10          6.1e-09       universal
#> 11          6.1e-09       universal
#> 212         4.5e-10 physicochemical
#> 213         4.5e-10 physicochemical

# attach the symbols to the search path and use them explicitly
attach(syms)
#> The following object is masked from package:base:
#> 
#>     F
hbar
#> [1] 1.054572e-34

# use constants with errors
detach(syms); attach(syms_with_errors)
#> The following object is masked from package:base:
#> 
#>     F
hbar
#> 1.05457180(1)e-34

# use constants with units
detach(syms_with_errors); attach(syms_with_units)
#> The following object is masked from package:base:
#> 
#>     F
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
#> 6  Newtonian constant of gravitation G_hbar.c0  6.70861e-39    GeV-2 c4
#>   rel_uncertainty      type
#> 1         0.0e+00 universal
#> 2         0.0e+00 universal
#> 3         0.0e+00 universal
#> 4         0.0e+00 universal
#> 5         4.7e-05 universal
#> 6         4.7e-05 universal

# number of constants per type
dplyr::count(codata, type, sort=TRUE)
#> # A tibble: 15 x 2
#>                          type     n
#>                         <chr> <int>
#>  1    atomic-nuclear-electron    31
#>  2      atomic-nuclear-proton    26
#>  3     atomic-nuclear-neutron    24
#>  4            physicochemical    24
#>  5      atomic-nuclear-helion    18
#>  6        atomic-nuclear-muon    17
#>  7            electromagnetic    17
#>  8                  universal    16
#>  9    atomic-nuclear-deuteron    15
#> 10     atomic-nuclear-general    11
#> 11         atomic-nuclear-tau    11
#> 12      atomic-nuclear-triton    11
#> 13                    adopted     7
#> 14       atomic-nuclear-alpha     7
#> 15 atomic-nuclear-electroweak     2
```
