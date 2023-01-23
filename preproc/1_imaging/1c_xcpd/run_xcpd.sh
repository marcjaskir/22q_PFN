#!/bin/bash

fmridir=${1}
outdir=${2}
sub=${3}

img=/cbica/projects/bbl_22q/software/singularity/xcp-abcd-0-0-8.simg

echo "Running XCP-D (nifti processing)"
echo
singularity run --cleanenv ${img} \
	${fmridir} \
	${outdir} \
	participant \
	--participant-label ${sub} \
	--despike \
	--lower-bpf 0.01 \
	--upper-bpf 0.08 \
	-p 36P \
	-f 10 \
	--cifti

echo "XCP-D complete for nifti processing"
echo
echo "Running XCP-D (cifti processing)"
echo
singularity run --cleanenv ${img} \
	${fmridir} \
	${outdir} \
	participant \
	--participant-label ${sub} \
	--despike \
	--lower-bpf 0.01 \
	--upper-bpf 0.08 \
	-p 36P \
	-f 10
echo "XCP-D complete for cifti processing"

echo "Moving log file and removing RUNNING tag"
rm -f logs/xcpd_${sub}_RUNNING
mkdir -p ${outdir}/xcp_abcd/${sub}/logs
mv logs/xcpd_${sub}* ${outdir}/xcp_abcd/${sub}/logs
