## ----setup,results="hide",echo=FALSE------------------------------------------
suppressPackageStartupMessages({
suppressMessages({
library(BiocFHIR)
library(DT)
library(jsonlite)
})
})

## ----takepeek-----------------------------------------------------------------
tfile = dir(system.file("json", package="BiocFHIR"), full=TRUE)
peek = jsonlite::fromJSON(tfile)
names(peek)
peek$resourceType
names(peek$entry)
length(names(peek$entry$resource))
class(peek$entry$resource)
dim(peek$entry$resource)
head(names(peek$entry$resource))

## ----txpeek-------------------------------------------------------------------
bu = process_fhir_bundle(tfile)
bu

## ----lkpo---------------------------------------------------------------------
po1 <- process_Observation(bu$Observation)
dim(po1)
datatable(po1)

## ----lksch--------------------------------------------------------------------
FHIR_retention_schemas()

## ----listt--------------------------------------------------------------------
ls("package:BiocFHIR") |> grep(x=_, "process_[A-Z]", value=TRUE)

## ----lkconds------------------------------------------------------------------
data("allin", package="BiocFHIR")
hascond = sapply(allin, function(x)length(x$Condition)>0)
oo = do.call(rbind, lapply(allin[hascond], function(x)process_Condition(x$Condition)))
dim(oo)
length(unique(oo$subject.reference))

## ----mostc--------------------------------------------------------------------
table(oo$code.coding.display) |> sort() |> tail()

## ----lksess-------------------------------------------------------------------
sessionInfo()

