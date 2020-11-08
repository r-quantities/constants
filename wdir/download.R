library(xml2)
library(quantities)
try(units::remove_symbolic_unit("c"), silent=TRUE)
install_conversion_constant("c", "m/s", 299792458)

base_url <- "https://physics.nist.gov/cgi-bin/cuu/"
list_url <- "Category?view=html&%s"
vals_url <- "Value?%s"
corr_url <- "CCValue?%s|ShowSecond=Browse&First=%s"
categories <- c(
  "Universal", "Electromagnetic", "Atomic+and+nuclear", "Physico-chemical",
  "Adopted+values", "Non-SI+units", "X-ray+values")

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
  nodes <- nodes[-length(nodes)]
  do.call(rbind, lapply(nodes, function(node) data.frame(
    quantity = trimws(xml_text(node)),
    symbol = sub(".*\\?(.*)\\|.*", "\\1", xml_attr(node, "href"))
  )))
}

# read all names, symbols, categories
codata <- extract_symbols("All+values")
types <- do.call(rbind, lapply(categories, function(x) data.frame(
  symbol = extract_symbols(x)$symbol,
  type = gsub("\\+", " ", x))
))
types <- aggregate(type ~ symbol, types, toString)
codata <- merge(codata, types, all=TRUE, sort=FALSE)

# read value, unit, uncertainty
values <- do.call(rbind, lapply(codata$symbol, function(symbol) {
  html <- read_html(sprintf(paste0(base_url, vals_url), symbol), symbol)
  if (!length(xml_children(html)))
    return(data.frame(symbol=symbol, value=NA, unit=NA, uncertainty=NA))

  raw <- xml_text(xml_find_all(html, "body/table/tr/td[2]/table/tr/td[2]"))
  raw <- gsub("\xc2\xa0", " ", raw[4])
  raw <- gsub("(?<=\\d) +(?=\\d)", "", raw, perl=TRUE)
  raw <- sub(" \t ", " ", raw)
  raw <- sub("x 10", "e", raw)
  raw <- sub("...", "", raw, fixed=TRUE)
  raw <- gsub(")-", ")^-", raw, fixed=TRUE)
  quantity <- parse_quantities(raw)

  data.frame(
    symbol = symbol,
    value = drop_quantities(quantity),
    uncertainty = errors(quantity),
    unit = as.character(units(quantity))
  )
}))
codata <- merge(codata, values, all=TRUE, sort=FALSE)
codata <- subset(codata, !is.na(value))

# fix symbols that are functions in base R (by appending a zero)
isfun <- sapply(codata$symbol, function(i) is.function(get0(i)))
codata$symbol[isfun] <- paste0(codata$symbol[isfun], 0)
#save(codata, file="data/codata.rda")
