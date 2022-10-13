#' process a bundle of FHIR R4 JSON
#' @importFrom jsonlite fromJSON
#' @param json_file character(1) path to text in JSON format
#' @return instance of FHIR.bundle, extending list
#' @examples
#' testf = system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun = process_fhir_bundle(testf)
#' tbun
#' @export
process_fhir_bundle = function(json_file) {
  dat = fromJSON(json_file)
  stopifnot(all(names(dat) %in% c("resourceType", "type", "entry")))
  stopifnot(dat$resourceType == "Bundle")
  de = dat$entry
  spl = split(de$resource, de$resource$resourceType)
  nres = names(spl)
  ok = intersect(nres, available_retention_schemas())
  scs = FHIR_retention_schemas()
  ans = lapply(ok, function(x) spl[[x]][, scs[[x]]])
  names(ans) = ok
  ans = lapply(ok, function(x) {class(ans[[x]]) = c(paste0("BiocFHIR.", x), class(ans[[x]])); ans[[x]]})
  names(ans) = ok # lapply does not propagate by default
  class(ans) = c("FHIR.bundle", "list")
  ans
}

#fixup_Patient = function(dfr) {
#  colclasses = vapply(dfr, class, character(1))
#  is_df = which(colclasses == "data.frame")
#  is_list = which(colclasses == "list")
#  ok = setdiff(seq_len(ncol(dfr)), c(is_df, is_list))
#  newd = dfr[,ok,drop=FALSE]
#  needsu = dfr[,is_df,drop=FALSE]
#  better = lapply(needsu, unnest, cols=c())
#  cbind(newd, needsu, better)
#}
  

#do_unnest = function(dfr) {
#  ok = setdiff(seq_len(ncol(dfr)), c(is_df, is_list))
#  newd = dfr[,ok,drop=FALSE]
#  better = lapply(needsu, unnest, cols=c())
#  fixl = lapply(dfr[,is_list,drop=FALSE], "[[", 1)
#  bfix = lapply(fixl, unnest, cols=c())
#  do.call(cbind, c(newd, better, bfix))
#}

#' print method
#' @param x BiocFHIR FHIR.bundle instance
#' @param \dots not used
#' @return print method
#' @export
print.FHIR.bundle = function(x, ...) {
  cat("BiocFHIR FHIR.bundle instance.\n")
  cat("  resource types are:\n")
  cat("  ", selectSome(names(x)))
  cat("\n")
}



#' list available 'retention schemas'
#' @return character vector
#' @examples
#' available_retention_schemas()
#' @export
available_retention_schemas = function()
 names(FHIR_retention_schemas())


#' from Biobase ...
#' @return character vector
#' @param obj any vector
#' @param maxToShow numeric(1)
selectSome = function (obj, maxToShow = 5) 
{
    len <- length(obj)
    if (maxToShow < 3) 
        maxToShow <- 3
    if (len > maxToShow) {
        maxToShow <- maxToShow - 1
        bot <- ceiling(maxToShow/2)
        top <- len - (maxToShow - bot - 1)
        nms <- obj[c(1:bot, top:len)]
        c(as.character(nms[1:bot]), "...", as.character(nms[-c(1:bot)]))
    }
    else if (is.factor(obj)) 
        as.character(obj)
    else obj
}

