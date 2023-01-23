#!/bin/bash

# Create pnc directory
if [ ! -d /cbica/projects/bbl_22q/data/derivatives/pnc ]; then
	mkdir /cbica/projects/bbl_22q/data/derivatives/pnc
fi

for dirs in /cbica/home/jaskirm/comp_space/22q/pnc_xcpd_outputs/sub-*xcp*; do

	dir_name=$(basename ${dirs})

	sub=$(echo ${dir_name} | awk -F '_' '{print $1}')

	if [ ! -d /cbica/projects/bbl_22q/data/derivatives/pnc/xcp_abcd/${sub} ]; then

		# Import fmriprep derivatives to project
		rsync -avzhL --progress ${dirs} /cbica/projects/bbl_22q/data/derivatives/pnc

		# Unzip
		unzip /cbica/projects/bbl_22q/data/derivatives/pnc/${dir_name} -d /cbica/projects/bbl_22q/data/derivatives/pnc/

		# Remove zip file
		rm -f /cbica/projects/bbl_22q/data/derivatives/pnc/${dir_name}

		# Save standard BIDS files just once, since it will continously prompt whether you want to overwrite it
		if [ ! -d /cbica/projects/bbl_22q/data/derivatives/pnc/xcpd_tmp ]; then
			mkdir /cbica/projects/bbl_22q/data/derivatives/pnc/xcpd_tmp
			mv /cbica/projects/bbl_22q/data/derivatives/pnc/xcp_abcd/logs /cbica/projects/bbl_22q/data/derivatives/pnc/xcpd_tmp
		else
			rm -rf /cbica/projects/bbl_22q/data/derivatives/pnc/xcp_abcd/logs
		fi

	fi

done

mv /cbica/projects/bbl_22q/data/derivatives/pnc/xcpd_tmp/logs /cbica/projects/bbl_22q/data/derivatives/pnc/xcp_abcd
rm -rf /cbica/projects/bbl_22q/data/derivatives/pnc/xcpd_tmp
