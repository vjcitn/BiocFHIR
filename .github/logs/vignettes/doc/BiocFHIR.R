## ----setup,results="hide",echo=FALSE------------------------------------------
suppressPackageStartupMessages({
suppressMessages({
library(BiocFHIR)
library(DT)
library(jsonlite)
})
})

## ----dobioc, eval=FALSE-------------------------------------------------------
#  BiocManager::install("BiocFHIR")

## ----lkd1---------------------------------------------------------------------
testf = dir(system.file("json", package="BiocFHIR"), full=TRUE)
tt = fromJSON(testf)
names(tt)
tt[1:2]
tte = tt$entry
class(tte)
dim(tte)
head(names(tte))
tter = tte$resource
dim(tter)
head(names(tter))
table(tter$resourceType)

## ----dobu1--------------------------------------------------------------------
bu1 = process_fhir_bundle(testf) # just give file path
bu1

## ----dopro1-------------------------------------------------------------------
cond1 = process_Condition(bu1$Condition)
datatable(cond1)

## ----doextr-------------------------------------------------------------------
tset = make_test_json_set()
tset[1]

## ----getalli------------------------------------------------------------------
myl = lapply(tset[1:10], process_fhir_bundle)
myl[1:2]
sapply(myl,length)

## ----lksess-------------------------------------------------------------------
sessionInfo()

