
<!-- README.md is generated from README.Rmd. Please edit that file -->

# constants: Reference on Constants, Units and Uncertainty

[![Build
Status](https://travis-ci.org/r-quantities/constants.svg?branch=master)](https://travis-ci.org/r-quantities/constants)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/constants)](https://cran.r-project.org/package=constants)
[![Downloads](https://cranlogs.r-pkg.org/badges/constants)](https://cran.r-project.org/package=constants)

The **constants** package provides the CODATA internationally
recommended values of the fundamental physical constants, provided as
symbols for direct use within the R language. Optionally, the values
with errors and/or the values with units are also provided if the
‘errors’ and/or the ‘units’ packages are installed. The Committee on
Data for Science and Technology (CODATA) is an interdisciplinary
committee of the International Council for Science which periodically
provides the internationally accepted set of values of the fundamental
physical constants. This package contains the “2018 CODATA” version,
published on May 2019.

> Eite Tiesinga, Peter J. Mohr, David B. Newell, and Barry N. Taylor
> (2020). The 2018 CODATA Recommended Values of the Fundamental Physical
> Constants (Web Version 8.1). Database developed by J. Baker, M. Douma,
> and S. Kotochigova. Available at <http://physics.nist.gov/constants>,
> National Institute of Standards and Technology, Gaithersburg, MD
> 20899.

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

# use the constants in a local environment
with(syms, c0)
#> [1] 299792458

# explore which constants are available
lookup("alpha particle", ignore.case=TRUE)
#>        symbol                                     quantity               type
#> 1         mal                          alpha particle mass Atomic and nuclear
#> 2       malc2        alpha particle mass energy equivalent Atomic and nuclear
#> 3    malc2mev alpha particle mass energy equivalent in MeV Atomic and nuclear
#> 4        malu                     alpha particle mass in u Atomic and nuclear
#> 5        mmal                    alpha particle molar mass Atomic and nuclear
#> 6      malsme           alpha particle-electron mass ratio Atomic and nuclear
#> 7      malsmp             alpha particle-proton mass ratio Atomic and nuclear
#> 89  mesmalpha        electron to alpha particle mass ratio Atomic and nuclear
#> 292      aral          alpha particle relative atomic mass               <NA>
#>            value uncertainty   unit
#> 1   6.644657e-27     2.0e-36     kg
#> 2   5.971920e-10     1.8e-19      J
#> 3   3.727379e+03     1.1e-06    MeV
#> 4   4.001506e+00     6.3e-11      u
#> 5   4.001506e-03     1.2e-12 kg/mol
#> 6   7.294300e+03     2.4e-07      1
#> 7   3.972600e+00     2.2e-10      1
#> 89  1.370934e-04     4.5e-15      1
#> 292 4.001506e+00     6.3e-11      1

# attach the symbols to the search path and use them explicitly
attach(syms)
mal
#> [1] 6.644657e-27

# use constants with errors
detach(syms); attach(syms_with_errors)
mal
#> 6.644657336(2)e-27

# use constants with units
detach(syms_with_errors); attach(syms_with_units)
mal
#> 6.644657e-27 [kg]

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
library(magrittr)
codata %>%
  tidyr::separate_rows(type, sep=", ") %>%
  dplyr::count(type, sort=TRUE)
#> # A tibble: 8 x 2
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
