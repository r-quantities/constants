# constants 1.0.0

Update to version 8.1, the 2018 CODATA recommended values (#7 addressing #6).
This version contains some breaking changes that are necessary to streamline
future updates and provide a stable symbol table:

- The `codata` table includes the absolute uncertainty instead of the relative
  one. Thus, the `rel_uncertainty` column has been dropped in favour of the new
  `uncertainty`. Also, columns have been slightly reordered.
- Symbol names for constants have changed. The old ones were hand-crafted and
  thus unmanageable. This release adopts the ASCII symbols defined by NIST in
  their webpage, except for those that collide with some base R function. In
  particular, there are two cases: `c`, the speed of light, has been renamed as
  `c0`; `sigma`, the Stefan-Boltzmann constant, has been renamed as `sigma0`.
- Constant types, or categories, (column `codata$type`) adopts the names defined
  by NIST in the webpage too. Some constants belong to more than one category
  (separated by comma); some others belong to no category (missing type).

There are some new features too:

- In addition to the `codata` data frame, this release includes `codata.cor`, a
  correlation matrix for all the constants.
- In addition to `syms_with_errors` and `syms_with_units`, there is a new list
  of symbols called `syms_with_quantities` (available if the optional
  `quantities` package is installed), which provides constant values with
  uncertainty **and** units.
- Experimental support for correlated values in `syms_with_errors` and
  `syms_with_quantities` is provided (disabled by default; see details in
  `help(syms)` for activation instructions).

# constants 0.0.2

- Use `units::as_units()` instead of the deprecated `units::parse_unit()` (#1).
- Install the speed of light as a unit (#2).
- Unitless constants now show a `1` instead of `unitless` as unit (#3).
- Unit `Ω` has been replaced by `ohm` (#4).
