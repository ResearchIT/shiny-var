docker pull wkpalan/shiny-var

# docker run -it \
if [ -d "/lss/research/vollbrec-lab" ]
then
docker run -d \
		-p 3838:3838 \
		--mount type=bind,source="/lss/research/vollbrec-lab/webapps/shiny-var/data",target="/srv/shiny-server/shiny-var/data" \
		wkpalan/shiny-var
else
	docker run -d \
		-p 3838:3838 \
		--mount type=bind,source="/media/data/lab_data/isilon-evlab/webapps/shiny-var"/data,target=/srv/shiny-server/shiny-var/data \
		wkpalan/shiny-var
fi
	# bash
#docker run -it -p 3838:80 wkpalan/shiny-var bash
