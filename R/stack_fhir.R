#' convert data of a given FHIR type in a list of bundles to a data.frame
#' @param blist list of FHIR bundles imported with process_fhir_bundle
#' @param type character(1) type, in names(blist[[1]]), e.g.
#' @param droperr logical(1) exclude records for which process_[type] fails, defaults to TRUE
#' @return data.frame
#' @examples
#' jj = make_test_json_set()
#' b2 = lapply(jj[1:2], process_fhir_bundle)
#' ss = stack_fhir(b2, "Procedure")
#' head(ss,2)
#' @export
stack_fhir = function(blist, type, droperr=TRUE) {
   if (type == "Patient") return(get_patient_stack(blist)) # Patient recs too heterogenous
   func = get(paste0("process_", type))
   pulls = lapply(blist, function(x) try(func(x[[type]]),silent=TRUE))
   haserr = sapply(pulls, function(x) inherits(x, "try-error"))
   if (any(haserr)) {
     message(sprintf("...bundle %d missing a component\n", which(haserr)))
     pulls = pulls[-which(haserr)]
     }
   ans = do.call(rbind, pulls)
   bad = grep("Error in func", ans[,1]) # issue with AllergyIntolerance
   if (length(bad)>0) {
     ans = ans[-bad,]
     }
   ans
}

get_patient_stack = function(blist) {
  pp = lapply(blist, function(x) process_Patient(x$Patient)) # produces single column
# extract intersection of all attributes
  props = rownames(pp[[1]])
  for (i in seq_len(length(pp)))  # first intersection nugatory
     props <- intersect(props, rownames(pp[[i]]))
  gg = lapply(pp, function(x) t(x[props,]))
  dd = data.frame(do.call(rbind,gg))
  names(dd) = props
  dd
}


#process_CarePlan = function (CarePlan) 
#{
#    stopifnot(inherits(CarePlan, "BiocFHIR.CarePlan"))
#    ac <- CarePlan$activity
#    recc <- vapply(ac, nrow, numeric(1))
#    idvec <- rep(CarePlan$id, recc)
#    getdc <- function(x) do.call(rbind, x$detail$code$coding)
#    ac_coding <- do.call(rbind, lapply(ac, getdc))
#    ac_status <- do.call(c, lapply(ac, function(x) x$detail$status))
#    ac_loc <- unname(unlist(lapply(ac, function(x) x$detail$location)))
##
## in synthea data, categories can be more complex; if there are two rows per entry,
## the second will have useful textual information, first will have a 'care plan' code
##
##    cattext = lapply(CarePlan$category, function(x) as.character(na.omit(x$text)))
#    last = function(x) x[length(x),]
#    cattext = lapply(CarePlan$category, last)
##    ml <- lapply(CarePlan$category, function(x) x$coding)
#    ml = lapply(cattext, function(x) x$coding)
#    uu <- unlist(ml, recursive = FALSE)
#    catd <- do.call(rbind, rep(uu, recc))
#    subref <- CarePlan$subject$reference
#    subid <- rep(subref, recc)
#    data.frame(id = idvec, ac_coding, status = ac_status, location = ac_loc, 
#        category = catd, subject.reference = subid)
#}
#
