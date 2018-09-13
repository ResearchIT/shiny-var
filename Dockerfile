FROM researchit/shiny-server
MAINTAINER Kokulapalan Wimalanathan <kokulapalan@gmail.com>
ENV REFRESHED_AT 2018-07-17
ENV TZ=America/Chicago

RUN echo "America/Chicago" > /etc/timezone

# Install yum dependencies
RUN yum -y install openssl-devel libcurl-devel mariadb-devel libxml2 libxml2-devel

#Change the Rscript to enable multicore installations
RUN ls

#Install the R packages
RUN R -e 'install.packages(c("data.table","ontologyIndex","jsonlite","WhopGenome"), repos="https://mirror.las.iastate.edu/CRAN/", Ncpus=8, INSTALL_opts="--no-html")'
RUN R -e 'install.packages(c("DT","shiny"), repos="https://cran.rstudio.com/", Ncpus=8,INSTALL_opts="--no-html")'
RUN R -e 'source("https://bioconductor.org/biocLite.R"); biocLite(c("GenomicFeatures"),Ncpus=8,INSTALL_opts="--no-html");'
RUN R -e 'source("https://bioconductor.org/biocLite.R"); biocLite(c("Rsamtools"),Ncpus=8,INSTALL_opts="--no-html");'

# #Copy the app files to the correct location and install needed packages
COPY app/ /srv/shiny-server/shiny-var/
RUN ls -lh

EXPOSE 3838
