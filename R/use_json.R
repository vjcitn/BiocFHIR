#' process a bundle of FHIR R4 JSON
#' @importFrom jsonlite fromJSON
#' @importFrom BiocBaseUtils selectSome
#' @param json_file character(1) path to text in JSON format
#' @param schemas list of character vectors defining expected fields, defaults to FHIR_retention_schemas()
#' @return instance of FHIR.bundle, extending list
#' @note If one encounters the error "Element ... lacks field", the schemas argument can be modified by removing
#' the noted field from the schema.
#' @examples
#' testf = system.file("json/Vince741_Rogahn59_6fa3d4ab-c0b6-424a-89d8-7d9105129296.json",
#'    package="BiocFHIR")
#' tbun = process_fhir_bundle(testf)
#' tbun
#' @export
process_fhir_bundle = function(json_file, schemas = FHIR_retention_schemas()) {
  dat = fromJSON(json_file)
  stopifnot(all(c("resourceType", "type", "entry") %in% names(dat)))
  stopifnot(dat$resourceType == "Bundle")
  de = dat$entry
  spl = split(de$resource, de$resource$resourceType)
  nres = names(spl)
  ok = intersect(nres, available_retention_schemas())
  scs = schemas
  check_bundle_restype = function(restype, splitbundle, schemas) {
   spln = names(splitbundle[[restype]])
   scsn = schemas[[restype]]
   data_lacks_field = setdiff(scsn, spln)
   if (length(data_lacks_field)>0) {
     message(sprintf("Element %s lacks field %s; retention schema must be modified to process this bundle.\n",
            restype, data_lacks_field))
     stop("Can't process bundle using existing retention schemas")
     }
   splitbundle[[restype]][,schemas[[restype]],drop=FALSE]
   }
  ans = lapply(ok, function(x) check_bundle_restype(x, spl, scs)) # fails if a field is missing
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
  cat("  ", BiocBaseUtils::selectSome(names(x)))
  cat("\n")
}



#' list available 'retention schemas'
#' @return character vector
#' @examples
#' available_retention_schemas()
#' @export
available_retention_schemas = function()
 names(FHIR_retention_schemas())


