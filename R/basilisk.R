pyverse <- c("fhir.resources==6.4.0",
"numpy==1.23.1",
"numpydoc==1.4.0",
"pandas==1.2.4")

bsklenv <- basilisk::BasiliskEnvironment(envname="bsklenv",
    pkgname="BiocSklearn",
    packages=pyverse)

