MYPASSWORD=mesi3

MYDATA=/qrisdata/ # point to your data folder

LOCALPORT=8787

docker container run -e PASSWORD=$MYPASSWORD \
  -v $MYDATA:/home/rstudio/mydata \
  -p $LOCALPORT:8787 \
  --rm dorianps/antsr:latest
