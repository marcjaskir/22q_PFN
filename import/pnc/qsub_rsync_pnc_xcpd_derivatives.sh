#!/bin/bash

if [ ! -d logs ]; then
	mkdir logs
fi

qsub -cwd -l h_vmem=16.0G,s_vmem=15.0G -j y -o logs/rsync_xcpd_\$JOB_ID.o rsync_pnc_xcpd_derivatives.sh
