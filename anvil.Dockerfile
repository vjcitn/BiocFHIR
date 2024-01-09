FROM us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.18.0
WORKDIR /home/rstudio
COPY --chown=rstudio:rstudio . /home/rstudio/
RUN Rscript -e "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/jammy/latest')); BiocManager::install(ask=FALSE); devtools::install('.', dependencies=TRUE, build_vignettes=TRUE, repos = BiocManager::repositories())"
