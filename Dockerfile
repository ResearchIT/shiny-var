FROM researchit/shiny-server
MAINTAINER Kokulapalan Wimalanathan <kokulapalan@gmail.com>
ENV REFRESHED_AT 2018-06-22
ENV TZ=America/Chicago
# ENV DEBIAN_FRONTEND=noninteractive

RUN echo "America/Chicago" > /etc/timezone

# Install apt dependencies
RUN yum -y install openssl-devel libcurl-devel mariadb-devel libxml2 libxml2-devel
# RUN apt-get update && apt-get install -y \
# 		build-essential \
# 		git \
# 		r-base \
# 		wget \
# 		libboost-dev \
# 		gdebi-core \
# 		vim \
# 		curl \
# 		libmysqld-dev \
# 		libcurl4-gnutls-dev \
# 		libssl-dev \
# 		libxml2-dev

#Change the Rscript to enable multicore installations
RUN sed -i 's/make/make -j8/g' /usr/lib64/R/etc/Renviron
# RUN mkdir /usr/share/doc/R-3.4.3/html/
RUN R -e 'install.packages(c("data.table","ontologyIndex","jsonlite","DT","WhopGenome"), repos="http://cran.us.r-project.org",INSTALL_opts="--no-html --no-docs", Ncpus=8,dependencies = T)'
RUN R -e 'source("https://bioconductor.org/biocLite.R"); biocLite(c("GenomicFeatures"),suppressUpdates=TRUE);'
RUN R -e 'source("https://bioconductor.org/biocLite.R"); biocLite(c("Rsamtools"),suppressUpdates=TRUE);'

# RUN mkdir /srv/shiny-server/shiny-var/
# COPY app/setup.R /srv/shiny-server/shiny-var/
# RUN Rscript /srv/shiny-server/shiny-var/setup.R

#Copy the app files to the correct location and install needed packages
COPY app/ /srv/shiny-server/shiny-var/

EXPOSE 3838
