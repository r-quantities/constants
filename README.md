
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="https://avatars1.githubusercontent.com/u/32303769?s=40&v=4"> Reference on Constants, Units and Uncertainty

<!-- badges: start -->

[![Build
Status](https://github.com/r-quantities/constants/workflows/build/badge.svg)](https://github.com/r-quantities/constants/actions)
[![Coverage
Status](https://codecov.io/gh/r-quantities/constants/branch/master/graph/badge.svg)](https://app.codecov.io/gh/r-quantities/constants)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/constants)](https://cran.r-project.org/package=constants)
[![Downloads](https://cranlogs.r-pkg.org/badges/constants)](https://cran.r-project.org/package=constants)
<!-- badges: end -->

The **constants** package provides the CODATA internationally
recommended values of the fundamental physical constants, provided as
symbols for direct use within the R language. Optionally, the values
with uncertainties and/or units are also provided if the ‘errors’,
‘units’ and/or ‘quantities’ packages are installed. The Committee on
Data for Science and Technology (CODATA) is an interdisciplinary
committee of the International Council for Science which periodically
provides the internationally accepted set of values of the fundamental
physical constants. This package contains the “2022 CODATA” version,
published on May 2014.

> Eite Tiesinga, Peter J. Mohr, David B. Newell, and Barry N. Taylor
> (2024). The 2022 CODATA Recommended Values of the Fundamental Physical
> Constants (Web Version 9.0). Database developed by J. Baker, M. Douma,
> and S. Kotochigova. Available at
> <https://physics.nist.gov/cuu/Constants/>, National Institute of
> Standards and Technology, Gaithersburg, MD 20899.

## Installation

Install the release version from CRAN:

``` r
install.packages("constants")
```

The installation from GitHub requires the
[remotes](https://cran.r-project.org/package=remotes) package.

``` r
# install.packages("remotes")
remotes::install_github("r-quantities/constants")
```

## Example

``` r
library(constants)

# the speed of light
syms$c0
#> [1] 299792458
# use the constants in a local environment
with(syms, c0)
#> [1] 299792458

# explore which constants are available
(lkp <- lookup("planck", ignore.case=TRUE))
#>        symbol                                  quantity
#> 137       nah                     molar Planck constant
#> 198         h                           Planck constant
#> 199       hev                  Planck constant in eV/Hz
#> 200      plkl                             Planck length
#> 201      plkm                               Planck mass
#> 202 plkmc2gev      Planck mass energy equivalent in GeV
#> 203    plktmp                        Planck temperature
#> 204      plkt                               Planck time
#> 230      hbar                   reduced Planck constant
#> 231    hbarev           reduced Planck constant in eV s
#> 232   hbcmevf reduced Planck constant times c in MeV fm
#>                          type        value uncertainty     unit
#> 137          Physico-chemical 3.990313e-10     0.0e+00 J/Hz/mol
#> 198 Universal, Adopted values 6.626070e-34     0.0e+00     J/Hz
#> 199                 Universal 4.135668e-15     0.0e+00    eV/Hz
#> 200                 Universal 1.616255e-35     1.8e-40        m
#> 201                 Universal 2.176434e-08     2.4e-13       kg
#> 202                 Universal 1.220890e+19     1.4e+14      GeV
#> 203                 Universal 1.416784e+32     1.6e+27        K
#> 204                 Universal 5.391247e-44     6.0e-49        s
#> 230 Universal, Adopted values 1.054572e-34     0.0e+00      J*s
#> 231                 Universal 6.582120e-16     0.0e+00     eV*s
#> 232   Universal, Non-SI units 1.973270e+02     0.0e+00   fm*MeV
idx <- as.integer(rownames(lkp))

# attach the symbols to the search path and use them explicitly
attach(syms[idx])
h
#> [1] 6.62607e-34
plkl
#> [1] 1.616255e-35

# the same with uncertainty
detach(syms[idx])
attach(syms_with_errors[idx])
h
#> 6.62607(0)e-34
plkl
#> 1.61626(2)e-35

# the same with units
detach(syms_with_errors[idx])
attach(syms_with_units[idx])
h
#> 6.62607e-34 [J/Hz]
plkl
#> 1.616255e-35 [m]

# the same with everything
detach(syms_with_units[idx])
attach(syms_with_quantities[idx])
h
#> 6.62607(0)e-34 [J/Hz]
plkl
#> 1.61626(2)e-35 [m]

# the whole dataset
head(codata)
#>     symbol                                     quantity               type
#> 1      mal                          alpha particle mass Atomic and nuclear
#> 2    malc2        alpha particle mass energy equivalent Atomic and nuclear
#> 3 malc2mev alpha particle mass energy equivalent in MeV Atomic and nuclear
#> 4     malu                     alpha particle mass in u Atomic and nuclear
#> 5     mmal                    alpha particle molar mass Atomic and nuclear
#> 6   malsme           alpha particle-electron mass ratio Atomic and nuclear
#>          value uncertainty   unit
#> 1 6.644657e-27     2.0e-36     kg
#> 2 5.971920e-10     1.8e-19      J
#> 3 3.727379e+03     1.1e-06    MeV
#> 4 4.001506e+00     6.3e-11      u
#> 5 4.001506e-03     1.2e-12 kg/mol
#> 6 7.294300e+03     2.4e-07      1

# number of constants per type
codata |>
  tidyr::separate_rows(type, sep=", ") |>
  dplyr::count(type, sort=TRUE)
#> # A tibble: 8 × 2
#>   type                   n
#>   <chr>              <int>
#> 1 Atomic and nuclear   173
#> 2 <NA>                  68
#> 3 Non-SI units          36
#> 4 Electromagnetic       26
#> 5 Physico-chemical      25
#> 6 Universal             16
#> 7 Adopted values        11
#> 8 X-ray values           6
```
