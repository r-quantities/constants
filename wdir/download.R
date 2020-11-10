library(xml2)
library(quantities)
# some units depend on the speed of light
try(units::remove_symbolic_unit("c"), silent=TRUE)
install_conversion_constant("c", "m/s", 299792458)

# URL parts ####################################################################

base_url <- "https://physics.nist.gov/cgi-bin/cuu/"
list_url <- "Category?view=html&%s"
vals_url <- "Value?%s"
corr_url <- "CCValue?%s|ShowSecond=Browse&First=%s"
categories <- c(
  "Universal", "Electromagnetic", "Atomic+and+nuclear", "Physico-chemical",
  "Adopted+values", "Non-SI+units", "X-ray+values")

# Helpers ######################################################################

read_html <- function(url, name, tmpdir="wdir/tmp") {
  dir.create(tmpdir, showWarnings=FALSE)
  dest <- file.path(tmpdir, name)
  if (!file.exists(dest))
    download.file(url, dest)
  xml2::read_html(dest)
}

extract_symbols <- function(x) {
  index <- read_html(sprintf(paste0(base_url, list_url), x), x)
  nodes <- xml_find_all(index, "body/table/tr/td[2]//a")
  nodes <- nodes[-length(nodes)] # remove "new search" link

  # quantity in contents, symbol in href
  do.call(rbind, lapply(nodes, function(node) data.frame(
    quantity = trimws(xml_text(node)),
    symbol = sub(".*\\?(.*)\\|.*", "\\1", xml_attr(node, "href"))
  )))
}

# Build codata table ###########################################################

# * quantity, symbol, type ----
codata <- extract_symbols("All+values")
types <- do.call(rbind, lapply(categories, function(x) data.frame(
  symbol = extract_symbols(x)$symbol,
  type = gsub("\\+", " ", x))
))
# some constants are listed in more than one category
types <- aggregate(type ~ symbol, types, toString)
codata <- merge(codata, types, all=TRUE, sort=FALSE)

# * value, unit, uncertainty ----
values <- do.call(rbind, lapply(codata$symbol, function(symbol) {
  html <- read_html(sprintf(paste0(base_url, vals_url), symbol), symbol)
  if (!length(xml_children(html)))
    return(NULL) # broken link safe-guard

  # take "concise form" and clean it
  raw <- xml_text(xml_find_all(html, "body/table/tr/td[2]/table/tr/td[2]"))[4]
  raw <- gsub("\xc2\xa0", " ", raw)                     # convert nbsp
  raw <- gsub("(?<=\\d) +(?=\\d)", "", raw, perl=TRUE)  # space between numbers
  raw <- sub(" \t ", " ", raw)                          # tab before unit
  raw <- sub("x 10", "e", raw)                          # use "e" notation
  raw <- sub("...", "", raw, fixed=TRUE)                # remove dots
  raw <- gsub(")-", ")^-", raw, fixed=TRUE)             # required by units

  # now we can parse it to capture everything reliably
  quantity <- parse_quantities(raw)
  data.frame(
    symbol = symbol,
    value = drop_quantities(quantity),
    uncertainty = errors(quantity),
    unit = as.character(units(quantity))
  )
}))
codata <- merge(codata, values, all=TRUE, sort=FALSE)
codata <- subset(codata, !is.na(value)) # remove broken links
rownames(codata) <- NULL

# Build correlation matrix #####################################################
# WARNING: this takes a lot of time currently, because there many pairs
# ~2/3 of these combinations have correlation 0 or 1, so this can be optimized

pairs <- t(combn(codata$symbol, 2))
corr <- do.call(rbind, apply(pairs, 1, function(pair) {
  html <- read_html(
    sprintf(paste0(base_url, corr_url), pair[1], pair[2]),
    paste0(pair, collapse="-"))
  if (!length(xml_children(html)))
    return(NULL) # broken link safe-guard

  # take the "r = ..." line
  raw <- xml_text(xml_find_all(html, "body/table/tr/td[2]/table/tr/td[1]"))
  raw <- gsub("\xc2\xa0| ", "", raw) # remove spaces
  raw <- grep("r=", raw, value=TRUE) # take the desired field

  data.frame(
    symbol1 = pair[1], symbol2 = pair[2],
    r = as.numeric(strsplit(raw, "=")[[1]][2])
  )
}))
# add first and last
fl <- lapply(codata$symbol[c(1, nrow(codata))], function(x) list(x, x, 1))
corr <- do.call(rbind, modifyList(fl, list(corr=corr)))
# spread to matrix
codata.cor <- tidyr::spread(corr, symbol2, r)
rownames(codata.cor) <- codata.cor$symbol1
codata.cor$symbol1 <- NULL
codata.cor <- as.matrix(codata.cor)
# reorder to match codata dataframe
symbol_order <- rank(codata$symbol)
codata.cor <- codata.cor[symbol_order, symbol_order]
# fill in the gaps
diag(codata.cor) <- 1
codata.cor[lower.tri(codata.cor)] <- t(codata.cor)[lower.tri(codata.cor)]

# Save data ####################################################################

# save original symbols as an attribute
attr(codata$symbol, "nist") <- codata$symbol
# fix symbols that are functions in base R (by appending a zero)
isfun <- sapply(codata$symbol, function(i) is.function(get0(i)))
codata$symbol[isfun] <- paste0(codata$symbol[isfun], 0)
colnames(codata.cor) <- codata$symbol
rownames(codata.cor) <- codata$symbol

#save(codata, file="data/codata.rda")
#save(codata.cor, file="data/codata.cor.rda")
#tools::resaveRdaFiles("data")
