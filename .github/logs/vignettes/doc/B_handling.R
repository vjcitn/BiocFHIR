## ----setup,results="hide",echo=FALSE------------------------------------------
suppressPackageStartupMessages({
suppressMessages({
library(BiocFHIR)
library(DT)
library(jsonlite)
library(rjsoncons)
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

## ----lkcat--------------------------------------------------------------------
head(which(vapply(peek$entry$resource$category, 
   function(x)!is.null(x), logical(1))))
peek$entry$resource$category[[6]]
peek$entry$resource$category[[6]]$coding
peek$entry$resource$category[[10]]

## ----lkpeek2------------------------------------------------------------------
peek2 = jsonlite::fromJSON(dir(system.file("json", package="BiocFHIR"), full=TRUE), simplifyVector=FALSE)
lapply(peek2$entry[1:5], function(x) names(x[["resource"]]))

## ----lktab--------------------------------------------------------------------
rtyvec = vapply(peek2$entry, function(x) 
   x[["resource"]]$resourceType, character(1))
table(rtyvec)

## ----getcond------------------------------------------------------------------
iscond = which(rtyvec == "Condition")
conds = peek2$entry[iscond]
length(conds)
str(conds[[1]])

## ----chkb---------------------------------------------------------------------
tbu = process_fhir_bundle(tfile)
tbu

## ----lktab2-------------------------------------------------------------------
ctab = process_Condition(tbu$Condition)
dim(ctab)
datatable(ctab)

## ----dojme--------------------------------------------------------------------
z = make_test_json_set()
myl = lapply(z[1:4], jsonlite::fromJSON) # list that rconsjson will convert to JSON
library(rjsoncons)
tmp = jmespath(myl, "[*].entry[0].resource.address") |> jsonlite::fromJSON()
do.call(rbind,lapply(tmp, function(x) x[,-(1:2)]))

## ----lksess-------------------------------------------------------------------
sessionInfo()

