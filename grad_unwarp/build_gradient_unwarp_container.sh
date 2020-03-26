
imageName='gradient_unwarp_singularity'
buildDate=`date +%Y%m%d`

#install neurodocker
#pip3 install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user

#upgrade neurodocker
#pip install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --upgrade

neurodocker generate docker \
	    --base=neurodebian:stretch-non-free \
	    --pkg-manager=apt \
	    --miniconda \
            conda_install="python=3.6 pytest traits nb_conda" \
            pip_install="numpy pydicom nose sphinx nibabel" \
            create_env="neuro" \
            activate=true \
            --user=root \
	    --install='python-numpy python-scipy' \
	    --copy v1.1.0.tar.gz /v1.1.0.tar.gz \
	    --run-bash='tar xzf v1.1.0.tar.gz && cd gradunwarp-1.1.0/' \
	    --run='python gradunwarp-1.1.0/setup.py install' \
            --workdir=/90days \
            --workdir=/30days \
	    --workdir=/QRISdata \
	    --workdir=/winmounts \
	    --workdir=/afm01 \
            --workdir=/RDS \
	    --workdir=/data \
	    --workdir=/short \
	    --workdir=/TMPDIR \
	    --workdir=/nvme \
	    --workdir=/local \
	    --user=neuro \
	> Dockerfile.${imageName}
#	docker login
	
docker build -t ${imageName}:$buildDate -f  Dockerfile.${imageName} .

docker run -it ${imageName}:$buildDate

docker tag ${imageName}:$buildDate caid/${imageName}:$buildDate

docker push caid/${imageName}:$buildDate
docker tag ${imageName}:$buildDate caid/${imageName}:latest
docker push caid/${imageName}:latest

echo "BootStrap:docker" > Singularity.${imageName}
echo "From:caid/${imageName}" >> Singularity.${imageName}

sudo singularity build ${imageName}_${buildDate}.simg Singularity.${imageName}

singularity shell --bind $PWD:/data ${imageName}_${buildDate}.simg
#singularity exec --bind $PWD:/data fsl_robex_20180305.simg runROBEX.sh /data/magnitude.nii.nii /data/stripped.nii /data/mask.nii

