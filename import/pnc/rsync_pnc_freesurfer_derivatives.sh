#!/bin/bash

for dirs in /cbica/home/jaskirm/comp_space/22q/pnc_fmriprep_outputs/sub-10*freesurfer*; do

	dir_name=$(basename ${dirs})

	# Import fmriprep derivatives to project
	rsync -avzhL --progress ${dirs} /cbica/projects/bbl_22q/data/derivatives/pnc

	# Unzip
	unzip /cbica/projects/bbl_22q/data/derivatives/pnc/${dir_name} -d /cbica/projects/bbl_22q/data/derivatives/pnc/

	# Remove zip file
	rm -f /cbica/projects/bbl_22q/data/derivatives/pnc/${dir_name}

done
