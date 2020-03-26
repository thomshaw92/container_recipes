
imageName='cpac'
buildDate=`date +%Y%m%d`

#install neurodocker
#pip3 install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user

#upgrade neurodocker
pip install neurodocker --user neurodocker --upgrade

neurodocker generate docker \
	--base ubuntu:16.04 \
	--pkg-manager apt \
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
	--workdir /tmp \
	--run "install autoconf autogen xutils-dev x11proto-print-dev" \
	--run "cd /tmp"/ \
	--run "git clone https://anongit.freedesktop.org/git/xorg/lib/libXp.git" \
	--run "cd libXp" \
	--run "./autogen.sh" \
	--run "configure" \
	--run "make" \
 	--run "make install" \
	> Dockerfile.${imageName} 
docker login
docker build -t ${imageName}:$buildDate -f  Dockerfile.${imageName} .

docker run -it ${imageName}:$buildDate

docker tag ${imageName}:$buildDate caid/${imageName}:$buildDate
docker push caid/${imageName}:$buildDate
docker tag ${imageName}:$buildDate caid/${imageName}:latest
docker push caid/${imageName}:latest

echo "BootStrap:docker" > Singularity.${imageName}
echo "From:caid/${imageName}" >> Singularity.${imageName}

sudo singularity build ${imageName}_${buildDate}.simg Singularity.${imageName}

#singularity shell --bind $PWD:/data ${imageName}_${buildDate}.simg
#singularity exec --bind $PWD:/data fsl_robex_20180305.simg runROBEX.sh /data/magnitude.nii.nii /data/stripped.nii /data/mask.nii

