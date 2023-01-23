#!/bin/bash

sub=${1}
ses=${2}
data_root=${3}

dir_name=${data_root}/raw/sub-${sub}/ses-${ses}/fmap
scans_tsv=${data_root}/raw/sub-${sub}/ses-${ses}/sub-${sub}_ses-${ses}_scans.tsv

if [ -f ${dir_name}/*magnitude11.json ]; then
	for mag_files in ${dir_name}/*magnitude*.nii.gz; do
		mag_file_name=$(basename ${mag_files} .nii.gz)
		echo "Changing filename of ${mag_file_name}..."
		if [ ${mag_file_name} == "sub-${sub}_ses-${ses}_magnitude11" ]; then

			# Correct file names
			mv "${dir_name}/${mag_file_name}.nii.gz" "${dir_name}/sub-${sub}_ses-${ses}_magnitude1.nii.gz"
			mv "${dir_name}/${mag_file_name}.json" "${dir_name}/sub-${sub}_ses-${ses}_magnitude1.json"

			# Correct reference to file in scans.tsv file
			if [ -e ${scans_tsv} ]; then
				sed -i "s/${mag_file_name}/sub-${sub}_ses-${ses}_magnitude1/g" "${scans_tsv}"
			fi

		elif [ ${mag_file_name} == "sub-${sub}_ses-${ses}_magnitude12" ]; then
			mv "${dir_name}/${mag_file_name}.nii.gz" "${dir_name}/sub-${sub}_ses-${ses}_magnitude2.nii.gz"
			mv "${dir_name}/${mag_file_name}.json" "${dir_name}/sub-${sub}_ses-${ses}_magnitude2.json"

			# Correct reference to file in _scans.tsv file
			if [ -e ${scans_tsv} ]; then
				sed -i "s/${mag_file_name}/sub-${sub}_ses-${ses}_magnitude2/g" "${scans_tsv}"
			fi

		else
			echo "WARNING: Atypical magnitude field map file name: ${mag_file_name}"
		fi
	done
fi

if [ -f ${dir_name}/*phase21.json ]; then
	for phase_files in ${dir_name}/*phase2*.nii.gz; do
		phase_file_name=$(basename ${phase_files} .nii.gz)

		# Remove files
		echo "Removing ${phase_file_name}..."
		rm ${dir_name}/${phase_file_name}.nii.gz
		rm ${dir_name}/${phase_file_name}.json

		# Correct references to files in _scans.tsv file
		if [ -e ${scans_tsv} ]; then
			sed -i "/${phase_file_name}/d" ${scans_tsv}
		fi

	done
fi

if [ -f ${dir_name}/*phase11.json ]; then
	for phase_files in ${dir_name}/*phase1*.nii.gz; do
		phase_file_name=$(basename ${phase_files} .nii.gz)
		echo "Changing filename of ${phase_file_name}..."
		if [ ${phase_file_name} == "sub-${sub}_ses-${ses}_phase11" ]; then

			# Correct file names
			mv "${dir_name}/${phase_file_name}.nii.gz" "${dir_name}/sub-${sub}_ses-${ses}_phase1.nii.gz"
			mv "${dir_name}/${phase_file_name}.json" "${dir_name}/sub-${sub}_ses-${ses}_phase1.json"
			# Correct references to files in _scans.tsv file
			if [ -e ${scans_tsv} ]; then
				sed -i "s/${phase_file_name}/sub-${sub}_ses-${ses}_phase1/g" "${scans_tsv}"
			fi

		elif [ ${phase_file_name} == "sub-${sub}_ses-${ses}_phase12" ]; then

			# Correct file names
			mv "${dir_name}/${phase_file_name}.nii.gz" "${dir_name}/sub-${sub}_ses-${ses}_phase2.nii.gz"
			mv "${dir_name}/${phase_file_name}.json" "${dir_name}/sub-${sub}_ses-${ses}_phase2.json"

			# Correct references to files in _scans.tsv file
			if [ -e ${scans_tsv} ]; then
				sed -i "s/${phase_file_name}/sub-${sub}_ses-${ses}_phase2/g" "${scans_tsv}"
			fi

		else
			echo "WARNING: Atypical phase field map file name: ${phase_file_name}"
		fi
	done
fi
