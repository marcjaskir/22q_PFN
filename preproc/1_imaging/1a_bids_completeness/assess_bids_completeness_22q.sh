#!/bin/bash

rawdir=/cbica/projects/bbl_22q/data/raw
outdir=/cbica/projects/bbl_22q/data/derivatives/completeness

# Check if file was already made; if not, add headers
if [ ! -f bids_curate_22q.csv ]; then
	echo "sub,ses,t1,fmap,idemo,jolo,rest" >> ${outdir}/bids_completeness_22q.csv
else
	exit
fi

# Check if file was already made; if not, add headers
if [ ! -f bids_fmaps_and_complete_func_22q.csv ]; then
        echo "sub" >> ${outdir}/bids_complete_fmaps_and_func_22q.csv
else
        exit
fi

for subs in ${rawdir}/sub-*/ses-*; do

	sub=$(echo ${subs} | awk -F '/' '{print $(NF-1)}')
	ses=$(basename ${subs})

	if [ -d ${subs}/anat ]; then
		t1=1

		# Check if fmaps, idemo, and rest directories exist
		if [ -d ${subs}/fmap ] && [ -f ${subs}/func/*idemo_bold.nii.gz ] && [ -f ${subs}/func/*rest_acq-singleband_bold.nii.gz ]; then
			echo ${sub} >> ${outdir}/bids_complete_fmaps_and_func_22q.csv
		fi

	else
		t1=0
	fi

	if [ -d ${subs}/fmap ]; then
		fmap=1
	else
		fmap=0
	fi

	if [ -f ${subs}/func/*idemo_bold.nii.gz ]; then
		idemo=1
	else
		idemo=0
	fi

	if [ -f ${subs}/func/*jolo_bold.nii.gz ]; then
		jolo=1
	else
		jolo=0
	fi

	if [ -f ${subs}/func/*rest_acq-singleband_bold.nii.gz ]; then
		rest=1
	else
		rest=0
	fi

	echo "${sub},${ses},${t1},${fmap},${idemo},${jolo},${rest}" >> ${outdir}/bids_completeness_22q.csv

done
