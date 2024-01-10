[![unit-pass.svg](https://raw.githubusercontent.com/vjcitn/BiocFHIR/main/.github/badges/unit-pass.svg)](https://raw.githubusercontent.com/vjcitn/BiocFHIR/main/.github/logs/unit-tests.txt)
![date.svg](https://raw.githubusercontent.com/vjcitn/BiocFHIR/main/.github/badges/date.svg)
[![anvil-container.svg](https://raw.githubusercontent.com/vjcitn/BiocFHIR/main/.github/badges/anvil-container.svg)](https://github.com/vjcitn/BiocFHIR/pkgs/container/BiocFHIR)
# BiocFHIR

Illustration of FHIR V4 Processing with synthea data


This R package addresses very basic tasks of parsing FHIR R4 documents in JSON format.

We will work through elements of the following concept map:

![coggle](https://github.com/vjcitn/BiocFHIR/raw/main/conceptmap.jpg)

# Use in AnVIL

In a terra workspace 

- use an Rstudio cloud environment
- start a git project
- use https://github.com/vjcitn/BiocFHIR as the repository
- in the Rstudio console 
    - use `BiocManager::install("vjcitn/BiocFHIR")` to get the software
    - navigate to the vignettes folder and knit the Rmd file to HTML
