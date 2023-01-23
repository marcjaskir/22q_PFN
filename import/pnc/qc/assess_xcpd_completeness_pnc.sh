#!/bin/bash

# Generate a list of PNC subjects with the following data for at least 1 session: T1, fmaps, rest, idemo
# NOTE: Scans without fmaps will have VARIANTNoFmap tags (and are therefore excluded)

xcp_dir_pnc=/cbica/projects/bbl_22q/data/derivatives/pnc/xcp_abcd
outdir=../../../../derivatives/pnc/xcp_abcd/xcpd_completeness

# Create output directory if necessary
if [ ! -d ${outdir} ]; then
	mkdir -p ${outdir}
fi

for sesdir in ${xcp_dir_pnc}/sub-*/ses-*; do

	sub=$(echo ${sesdir} | awk -F '/' '{print $(NF-1)}')
	ses=$(echo ${sesdir} | awk -F '/' '{print $NF}')

	# Check if rest scans are present
	if [ ! -f ${sesdir}/func/${sub}_${ses}_task-rest_acq-singleband_space-MNI152NLin6Asym_desc-residual_smooth_res-2_bold.nii.gz ]; then
		continue
	fi

	# Check if idemo scans are present
	if [ ! -f ${sesdir}/func/${sub}_${ses}_task-idemo_space-MNI152NLin6Asym_desc-residual_smooth_res-2_bold.nii.gz ]; then
		continue
	fi

	echo ${sub} >> ${outdir}/xcpd_completeness_fmaps_and_func_pnc.txt

done
