
imageName='deepseacat_singularity'
buildDate=`date +%Y%m%d`

#install neurodocker
#pip3 install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --user

#upgrade neurodocker
#pip install --no-cache-dir https://github.com/kaczmarj/neurodocker/tarball/master --upgrade

neurodocker generate docker \
	    --base=neurodebian:stretch-non-free \
	    --pkg-manager=apt \
	    --install convert3d ants fsl gcc g++ graphviz tree \
            git-annex-standalone vim emacs-nox nano less ncdu \
            tig git-annex-remote-rclone octave netbase \
	    --add-to-entrypoint "source /etc/fsl/fsl.sh" \
	    --ants version=2.3.1 \
	    --fsl version=5.0.11 \
	    -e FSLOUTPUTTYPE=NIFTI_GZ \
	    --convert3d version=nightly \
	    --miniconda \
	    conda_install="python=3.6 pytest jupyter jupyterlab jupyter_contrib_nbextensions
                   traits pandas matplotlib scikit-learn scikit-image seaborn nbformat nb_conda" \
	    pip_install="https://github.com/nipy/nipype/tarball/master
                 https://github.com/INCF/pybids/tarball/master
                 nilearn nipy duecredit nbval" \
	    create_env="neuro" \
	    activate=true \
	    --run-bash 'source activate neuro && jupyter nbextension enable exercise2/main && jupyter nbextension enable spellchecker/main' \
	    --user=root \
	    --run 'mkdir /data && chmod 777 /data && chmod a+s /data' \
	    --run 'mkdir /output && chmod 777 /output && chmod a+s /output' \
	    --user=neuro \
	    --run-bash 'source activate neuro' \
	    --user=root \
	    --run 'rm -rf /opt/conda/pkgs/*' \
	    --user=neuro \
	    --run 'mkdir -p ~/.jupyter && echo c.NotebookApp.ip = \"0.0.0.0\" > ~/.jupyter/jupyter_notebook_config.py' \
	    --workdir /home/neuro/nipype_tutorial \
	    --workdir=/proc_temp \
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
	#docker login
	
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

