FROM ubuntu:bionic
MAINTAINER Kokulapalan Wimalanathan <kokulapalan@gmail.com>
ENV REFRESHED_AT 2018-05-23
ENV TZ=America/Chicago
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "America/Chicago" > /etc/timezone

RUN apt-get update && apt-get install -y \
		build-essential \
		git \
		r-base \
		wget \
		libboost-dev \
		gdebi-core \
		vim \
		curl \
		libmysqld-dev \
		libcurl4-gnutls-dev \
		libssl-dev \
		libxml2-dev

RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.7.907-amd64.deb
RUN dpkg -i shiny-server-1.5.7.907-amd64.deb && rm shiny-server-1.5.7.907-amd64.deb

COPY shiny-server.conf /etc/shiny-server/
COPY shiny-server.sh /usr/bin/shiny-server.sh

RUN mkdir -p /srv/shiny-server/shiny-var
COPY app/setup.R /srv/shiny-server/shiny-var/setup.R
RUN sed -i 's/make/make -j8/g' /usr/lib/R/etc/Renviron
RUN Rscript /srv/shiny-server/shiny-var/setup.R

COPY app/ /srv/shiny-server/shiny-var/

EXPOSE 80

CMD ["/usr/bin/shiny-server.sh"]
