# docker run -it \
docker run -d \
	-p 3838:80 \
	--mount type=bind,source="$(pwd)"/data,target=/srv/shiny-server/shiny-var/data \
	wkpalan/shiny-var
	# bash
#docker run -it -p 3838:80 wkpalan/shiny-var bash
