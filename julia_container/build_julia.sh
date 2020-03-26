imageName='julia_simg'
buildDate=`date +%Y%m%d`

#install neurodocker
#pip3 install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user

#upgrade neurodocker
#pip install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --upgrade

neurodocker generate singularity\
	    --base=neurodebian:stretch-non-free \
	    --pkg-manager apt \
	    --install libxt6 libxext6 libxtst6 libgl1-mesa-glx libc6 libice6 libsm6 libx11-6 curl tar gzip \
	    --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
	    --run="chmod +x /usr/bin/ll" \
	    --copy  julia-1.0.1 /julia-1.0.1 \
	    --export PATH=/julia-1.0.1/bin:$PATH \
	    --export LD_LIBRARY_PATH=/julia-1.0.1/lib:/julia-1.0.1/lib/julia:$LD_LIBRARY_PATH \
	    --export LC_ALL=C \
	    --workdir /proc_temp \
	    --workdir /90days \
	    --workdir /30days \
	    --workdir /QRISdata \
	    --workdir /RDS \
	    --workdir /data \
	    --workdir /home/neuro \
	    --workdir /TMPDIR \
	    > Dockerfile.${imageName}

docker build -t ${imageName}:$buildDate -f  Dockerfile.${imageName} .
#test:
docker run -it ${imageName}:$buildDate

docker tag ${imageName}:$buildDate caid/${imageName}:$buildDate
docker login
docker push caid/${imageName}:$buildDate
docker tag ${imageName}:$buildDate caid/${imageName}:latest
docker push caid/${imageName}:latest

echo "BootStrap:docker" > Singularity.${imageName}
echo "From:caid/${imageName}" >> Singularity.${imageName}

rm ${imageName}_${buildDate}.simg
sudo singularity build ${imageName}_${buildDate}.simg Singularity.${imageName}

#singularity shell --bind $PWD:/data ${imageName}_${buildDate}.simg


