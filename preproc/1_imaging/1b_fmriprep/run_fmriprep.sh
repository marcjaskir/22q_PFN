#!/bin/bash

data_root=${1}
sub=${2}
work_dir=${3}

img=~/software/singularity/fmriprep-20.2.3.simg
fs_license=/cbica/projects/bbl_22q/software/freesurfer/license.txt
raw_dir=/data/raw
out_dir=/data/derivatives

singularity run --cleanenv -B ${data_root}:/data \
	${img} \
	${raw_dir} \
	${out_dir} \
	participant \
	-w ${work_dir} \
	--n_cpus 1 \
	--stop-on-first-crash \
	--fs-license-file ${fs_license} \
	--output-spaces MNI152NLin6Asym:res-2 \
	--participant-label ${sub} \
	--force-bbr \
	--cifti-output 91k \
	--use-syn-sdc \
	--force-syn \
	--verbose

echo "fmriprep complete!"
echo "Moving log file and deleting working directories"	

# Move log file
log_file=${work_dir}.o
log_dir=${data_root}/derivatives/fmriprep/${sub}/logs
if [ ! -d ${log_dir} ]; then
	mkdir -p ${log_dir}
fi
mv ${log_file} ${log_dir}

# Remove working directory
rm -rf ${work_dir}

# Removing running file
rm work_dirs/fmriprep_${sub}_RUNNING
