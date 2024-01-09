## ----setup,results="hide",echo=FALSE------------------------------------------
suppressPackageStartupMessages({
suppressMessages({
library(BiocFHIR)
library(DT)
library(jsonlite)
library(graph)
library(igraph)
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

## ----lkg1---------------------------------------------------------------------
data(allin)
g = make_condition_graph(allin)
g
names(g)

## ----lkn----------------------------------------------------------------------
getHumanName(allin[[1]]$Patient)

## ----lke----------------------------------------------------------------------
library(graph)
nodes(g$graph)[edgeL(g$graph)[["Ankunding277D'Amore443"]]$edges]

## ----showa--------------------------------------------------------------------
g = add_procedures(g, allin)
g

## ----morep--------------------------------------------------------------------
display_proccond_igraph( build_proccond_igraph( allin ))

## ----lksess-------------------------------------------------------------------
sessionInfo()

