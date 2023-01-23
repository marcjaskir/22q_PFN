#!/bin/bash

data_root=../../..
rawdir=${data_root}/raw
sublist=../bids/bids_fmaps_and_complete_func_22q.csv

# Create work_dir directory, if necessary
if [ ! -d work_dirs ]; then
	mkdir work_dirs
fi

# Iterate over subjects to run through fmriprep
for subdir in ${rawdir}/sub-*; do

	sub=$(basename ${subdir})

	# Check that subject is in subject list
	if [ -z $(grep -P ${sub} ${sublist} | awk '{print $1}') ]; then
		echo "Skipping ${sub} - not in subject list"
		continue
	fi

	# Check that subject hasn't already completed fmriprep
	if [ -d ${data_root}/derivatives/fmriprep/${sub} ]; then
		echo "${sub} already has an fmriprep directory"
		continue
	fi

	# Check that the subject isn't currently running
	if [ -f work_dirs/fmriprep_${sub}_RUNNING ]; then
		echo "ERROR: ${sub} is already queued or has failed"
		continue
	else
		touch work_dirs/fmriprep_${sub}_RUNNING
	fi

	# Submit fmriprep
	echo "Submitting ${sub}"
	qsub -cwd -l h_vmem=64.0G,s_vmem=63.0G -pe threaded 8 \
                -j y -o work_dirs/fmriprep_${sub}_\$JOB_ID.o \
                run_fmriprep.sh \
                        ${data_root} ${sub} work_dirs/fmriprep_${sub}_\$JOB_ID

done
