FROM researchit/shiny-server
MAINTAINER Kokulapalan Wimalanathan <kokulapalan@gmail.com>
ENV REFRESHED_AT 2018-06-22
ENV TZ=America/Chicago
# ENV DEBIAN_FRONTEND=noninteractive

RUN echo "America/Chicago" > /etc/timezone

# Install apt dependencies
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
# RUN sed -i 's/make/make -j8/g' /usr/lib/R/etc/Renviron

#Copy the app files to the correct location and install needed packages
COPY app/ /srv/shiny-server/shiny-var/
RUN Rscript /srv/shiny-server/shiny-var/setup.R
