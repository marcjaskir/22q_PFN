#!/bin/bash

rawdir=/cbica/projects/bbl_22q/data/raw
outdir=/cbica/projects/bbl_22q/data/derivatives/scan_dates

echo "sub,ses,scan_date" >> ${outdir}/22q_scan_dates.csv

for sesdir in ${rawdir}/sub-*/ses-*; do

	sub=$(echo ${sesdir} | awk -F '/' '{print $(NF-1)}')
	ses=$(basename ${sesdir})

	date=$(sed -n '2p' ${sesdir}/${sub}_${ses}_scans.tsv | awk -F '\t' '{print $(NF-2)}' | cut -d 'T' -f1)
	echo "${sub},${ses},${date}" >> ${outdir}/22q_scan_dates.csv

done
