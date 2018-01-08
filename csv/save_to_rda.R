codata <- read.csv("csv/codata.csv", as.is=TRUE)
codata$unit <- enc2utf8(codata$unit)
save(codata, file="data/codata.rda", ascii=TRUE, compress=TRUE)
