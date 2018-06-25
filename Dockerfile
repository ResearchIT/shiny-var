FROM researchit/shiny-server
MAINTAINER Kokulapalan Wimalanathan <kokulapalan@gmail.com>
ENV REFRESHED_AT 2018-06-22
ENV TZ=America/Chicago
# ENV DEBIAN_FRONTEND=noninteractive

RUN echo "America/Chicago" > /etc/timezone

# Install yum dependencies
RUN yum -y install openssl-devel libcurl-devel mariadb-devel libxml2 libxml2-devel

#Change the Rscript to enable multicore installations
#RUN sed -i 's/make/make -j8/g' /usr/lib64/R/etc/Renviron
RUN ls

#Install the R packages
RUN R -e 'install.packages(c("data.table","ontologyIndex","jsonlite","DT","WhopGenome"), repos="http://cran.us.r-project.org",Ncpus=8)'
RUN R -e 'source("https://bioconductor.org/biocLite.R"); biocLite(c("GenomicFeatures"));'
RUN R -e 'source("https://bioconductor.org/biocLite.R"); biocLite(c("Rsamtools"));'

#Copy the app files to the correct location and install needed packages
COPY app/ /srv/shiny-server/shiny-var/

EXPOSE 3838
