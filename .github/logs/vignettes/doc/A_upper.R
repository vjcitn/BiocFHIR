## ----setup,results="hide",echo=FALSE------------------------------------------
suppressPackageStartupMessages({
suppressMessages({
library(BiocFHIR)
library(DT)
library(jsonlite)
})
})

## ----takepeek-----------------------------------------------------------------
peek = jsonlite::fromJSON(dir(system.file("json", package="BiocFHIR"), full=TRUE))
names(peek)
peek$resourceType
names(peek$entry)
length(names(peek$entry$resource))
class(peek$entry$resource)
dim(peek$entry$resource)
head(names(peek$entry$resource))

## ----lkcli--------------------------------------------------------------------
table(peek$entry$resource$resourceType)

## ----lksess-------------------------------------------------------------------
sessionInfo()

