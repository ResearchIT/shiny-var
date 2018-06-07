docker build -t wkpalan/shiny-var . $@
if [[ ! -d "data" ]]; then
    	wget https://osf.io/4f7j2/download -O data.tar && tar -xvf data.tar
else
	echo "The data directory already exists"
fi
