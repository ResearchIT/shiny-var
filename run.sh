docker pull wkpalan/shiny-var

if [[ ! -d "data" ]]; then
    	wget https://osf.io/6r7wg/download -O data.tar && tar -xvf data.tar && rm data.tar
else
	echo "The data directory already exists"
fi

# docker run -it \
docker run -d \
	-p 3838:80 \
	--mount type=bind,source="$(pwd)"/data,target=/srv/shiny-server/shiny-var/data \
	wkpalan/shiny-var
	# bash
#docker run -it -p 3838:80 wkpalan/shiny-var bash
