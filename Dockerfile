ARG BIOC_VERSION
FROM bioconductor/bioconductor_docker:${BIOC_VERSION}
COPY . /opt/pkg

# Update Quarto
RUN apt-get update && apt-get install gdebi-core -y
RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb && gdebi --non-interactive quarto-linux-amd64.deb

# Install book package 
RUN Rscript -e 'repos <- BiocManager::repositories() ; remotes::install_local(path = "/opt/pkg/", repos=repos, dependencies=TRUE, build_vignettes=FALSE, upgrade=TRUE) ; sessioninfo::session_info(installed.packages()[,"Package"], include_base = TRUE)'

## Build/install using same approach than BBS
RUN R CMD INSTALL /opt/pkg
RUN R CMD build --keep-empty-dirs --no-resave-data /opt/pkg
