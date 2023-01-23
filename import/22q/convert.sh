#!/bin/bash

sub=${1}
ses=${2}
dcmdir=${3}
niidir=${4}

heuimg=~/software/singularity/heudiconv_0.5.4.sif
data_root=../../..

# if subject exists in .heudiconv manifest, delete it
if [ -d ${data_root}/raw/.heudiconv/${sub}/ses-${ses} ]; then
	echo "WARNING: ${sub} - ${ses} was previously run, deleting .heudiconv manifest"
	rm -rf ${data_root}/raw/.heudiconv/${sub}/ses-${ses}
fi

# run heudiconv
singularity run -B ${data_root}:/data ${heuimg} \
	--files ${dcmdir} \
	-o ${niidir} \
	--subjects ${sub} \
	--ses ${ses} \
	-f $(pwd)/heuristic.py \
	-c dcm2niix -b --overwrite

# Correct field map filenames
./correct_fmap_fnames.sh ${sub} ${ses} ${data_root}

# Insert IntendedFor field in fmap jsons
./insertIntendedFor.py ${data_root}/raw/sub-${sub}/ses-${ses}

# Insert EchoTime1 and EchoTime2 fields in phasediff fmap jsons
if [ -e ${data_root}/raw/sub-${sub}/ses-${ses}/fmap/sub-${sub}_ses-${ses}_phasediff.json  ]; then
	./insertEchoTime.py ${data_root}/raw/sub-${sub}/ses-${ses}
fi

# remove events.tsv files
echo "Removing events.tsv files..."
rm ${data_root}/raw/sub-${sub}/ses-${ses}/func/*events.tsv
