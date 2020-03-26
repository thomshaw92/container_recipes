imageName='spm_fsl_mrtrix'
buildDate=`date +%Y%m%d`

#install neurodocker
#pip3 install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user

#upgrade neurodocker
#pip install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --upgrade

neurodocker generate docker \
	    --base=neurodebian:stretch-non-free \
	    --pkg-manager apt \
	    --install libxt6 libxext6 libxtst6 libgl1-mesa-glx libc6 libice6 libsm6 libx11-6 \
	    --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
	    --run="chmod +x /usr/bin/ll" \
	    --fsl version=5.0.11 \
	    -e FSLOUTPUTTYPE=NIFTI_GZ \
	    --mrtrix3 version=3.0_RC3 \
	    --spm12 version=r7219 \
	    --workdir /proc_temp \
	    --workdir /90days \
	    --workdir /30days \
	    --workdir /QRISdata \
	    --workdir /RDS \
	    --workdir /data \
	    --workdir /short \
	    --workdir /home/neuro \
	    --workdir /TMPDIR \
	    --workdir /nvme \
	    --workdir /local \
	    --user=neuro \
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
#singularity exec --bind $PWD:/data fsl_robex_20180305.simg runROBEX.sh /data/magnitude.nii.nii /data/stripped.nii /data/mask.nii

