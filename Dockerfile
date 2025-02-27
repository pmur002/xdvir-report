
# Base image
FROM ubuntu:24.04
MAINTAINER Paul Murrell <paul@stat.auckland.ac.nz>

# Install R 
# https://cran.stat.auckland.ac.nz/bin/linux/ubuntu
# update indices
RUN apt update -qq
# install helper packages we need
RUN apt install -y --no-install-recommends software-properties-common dirmngr
RUN apt install -y --no-install-recommends wget
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# add the repo from CRAN -- lsb_release adjusts to 'noble' or 'jammy' or ... as needed
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
# install R itself
RUN apt install -y --no-install-recommends r-base

# For building packages from source
RUN apt install -y --no-install-recommends build-essential \
    xsltproc \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    bibtex2html \
    subversion 
RUN apt install -y --no-install-recommends \
    libz-dev \
    libfontconfig1-dev \
    libfreetype-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev

# For building the report
RUN Rscript -e 'install.packages(c("knitr", "devtools"), repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("xml2", "1.2.2", repos="https://cran.rstudio.com/")'

# Tools used in the report
RUN apt-get update && apt-get install -y \
    texlive-full 

# Packages used in the report
RUN Rscript -e 'library(devtools); install_version("ggplot2", "3.5.1", repos="https://cran.rstudio.com/")'

# Package dependencies
# 'xml2', 'ggplot2', 'knitr' already installed
RUN Rscript -e 'library(devtools); install_version("hexView", "0.3-4", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("tinytex", "0.55", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("rlang", "1.1.5", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("systemfonts", "1.2.1", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("gridBezier", "1.1-1", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("rmarkdown", "2.29", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("gridGraphics", "0.5-1", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("gggrid", "0.2-0", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("cli", "3.6.4", repos="https://cran.rstudio.com/")'

# Using COPY will update (invalidate cache) if the tar ball has been modified!
COPY xdvir_0.1-2.tar.gz /tmp/
RUN R CMD INSTALL /tmp/xdvir_0.1-2.tar.gz
# RUN Rscript -e 'devtools::install_github("pmur002/xdvir@v0.1-2")'

RUN apt-get install -y locales && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

ENV TERM dumb

