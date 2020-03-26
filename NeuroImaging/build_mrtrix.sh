
imageName='mrtrix'
buildDate=`date +%Y%m%d`

#install neurodocker
#pip3 install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user

#upgrade neurodocker
pip install neurodocker --user neurodocker --upgrade

neurodocker generate docker \
	--base=neurodebian:stretch-non-free \
	--pkg-manager=apt \
	--workdir /proc_temp \
        --workdir /90days \
        --workdir /30days \
	--workdir /QRISdata \
        --workdir /RDS \
	--workdir /data \
	--workdir /short \
	--mrtrix3 version=3.0_RC3 \
	--workdir /home/neuro \
	--workdir /TMPDIR \
	--workdir /nvme \
	--workdir /local \
	> Dockerfile.${imageName}

docker build -t ${imageName}:$buildDate -f  Dockerfile.${imageName} .

docker run -it ${imageName}:$buildDate

docker tag ${imageName}:$buildDate caid/${imageName}:$buildDate
docker login
docker push caid/${imageName}:$buildDate
docker tag ${imageName}:$buildDate caid/${imageName}:latest
docker push caid/${imageName}:latest

echo "BootStrap:docker" > Singularity.${imageName}
echo "From:caid/${imageName}" >> Singularity.${imageName}

sudo singularity build ${imageName}_${buildDate}.simg Singularity.${imageName}

#singularity shell --bind $PWD:/data ${imageName}_${buildDate}.simg
#singularity exec --bind $PWD:/data fsl_robex_20180305.simg runROBEX.sh /data/magnitude.nii.nii /data/stripped.nii /data/mask.nii

