#!/bin/bash

xcpdir=/cbica/projects/bbl_22q/data/derivatives/xcpd/xcp_abcd
outdir=/cbica/projects/bbl_22q/data/derivatives/xcpd/xcp_abcd/xcpd_completeness

# Create output directory if necessary
if [ ! -d ${outdir} ]; then
	mkdir -p ${outdir}
fi

# Create file header
nvols_summary=${outdir}/xcpd_completeness_nvols_22q.csv
if [ ! -f ${nvols_summary} ]; then
	echo "sub,ses,scan,nvols" > ${nvols_summary}
fi

# Save number of volumes for each functional scan
for scans in ${xcpdir}/sub-*/ses-*/func/*residual_smooth_res-2_bold.nii.gz; do
	sub=$(echo ${scans} | awk -F '/' '{print $(NF-3)}')
	ses=$(echo ${scans} | awk -F '/' '{print $(NF-2)}')
	scan=$(basename ${scans} | cut -d'_' -f3)

	# Skip jolo
	if [ ${scan} != task-jolo ]; then
		nvols=$(fslnvols ${scans})
		echo "${sub},${ses},${scan},${nvols}" >> ${nvols_summary}
	fi

done
