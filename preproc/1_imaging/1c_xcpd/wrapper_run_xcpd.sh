#!/bin/bash

fmridir=../../../derivatives/fmriprep
outdir=../../../derivatives/xcpd

if [ ! -d logs ]; then
	mkdir logs
fi

for subdir in ${fmridir}/sub-*; do

	sub=$(basename ${subdir})
	if [ -d ${fmridir}/${sub} ]; then

		# Check that subject isn't already completed
		if [ -d ${outdir}/${sub} ]; then
			echo "${sub} is already completed"
			continue
		fi

		# Check that subject isn't currently running
		if [ -f logs/xcpd_${sub}_RUNNING ]; then
			echo "${sub} is already queued or has failed"
			continue
		fi

		# Run
		touch logs/xcpd_${sub}_RUNNING
		qsub -cwd -l h_vmem=15.0G,s_vmem=15.0G -j y \
			-o logs/xcpd_${sub}_\$JOB_ID.o \
			run_xcpd.sh \
				${fmridir} \
				${outdir} \
				${sub}

	fi

done
