context("constants")

test_that("the dataset has the right number of columns", {
  expect_equal(names(codata), c("symbol", "quantity", "type", "value", "uncertainty", "unit"))
})

test_that("the symbols are correctly set", {
  expect_true(all(do.call(c, lapply(syms, is.numeric))))
  expect_equal(nrow(codata), length(syms))
  expect_equal(as.vector(codata$symbol), names(syms))

  if (requireNamespace("errors", quietly = TRUE)) {
    expect_true(all(do.call(c, lapply(syms_with_errors, inherits, "errors"))))
    expect_equal(nrow(codata), length(syms_with_errors))
    expect_equal(as.vector(codata$symbol), names(syms_with_errors))
    expect_equal(as.numeric(syms), as.numeric(syms_with_errors))
  } else expect_null(syms_with_errors)

  if (requireNamespace("units", quietly = TRUE)) {
    expect_true(all(do.call(c, lapply(syms_with_units, inherits, "units"))))
    expect_equal(nrow(codata), length(syms_with_units))
    expect_equal(as.vector(codata$symbol), names(syms_with_units))
    expect_equal(as.numeric(syms), as.numeric(syms_with_units))
  } else expect_null(syms_with_units)

  if (requireNamespace("quantities", quietly = TRUE)) {
    expect_true(all(do.call(c, lapply(syms_with_quantities, inherits, "quantities"))))
    expect_equal(nrow(codata), length(syms_with_quantities))
    expect_equal(as.vector(codata$symbol), names(syms_with_quantities))
    expect_equal(as.numeric(syms), as.numeric(syms_with_quantities))
  } else expect_null(syms_with_quantities)
})
