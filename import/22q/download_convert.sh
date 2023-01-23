#!/bin/bash

# script that will (1) import from flywheel and (2) convert to bids using heudiconv

sub=${1}
ses=${2}
logfile=${3}

dicomdir=../../../source/sub-${sub}/ses-${ses}/dicom
dicomdir_relative=/data/source/sub-${sub}/ses-${ses}/dicom
niidir=../../../raw
niidir_relative=/data/raw

# initialize conda environment
source activate flywheel

###### (1) import from flywheel ######
echo "Importing from flywheel ..."
./download.sh ${sub} ${ses} ${dicomdir}
echo "Completed import of DICOMs from flywheel"

###### (2) convert to BIDS ######
echo "Converting to BIDS format ..."
./convert.sh ${sub} ${ses} ${dicomdir_relative} ${niidir_relative}

###### (3) move logfile ######
logdir=${niidir}/sub-${sub}/ses-${ses}/logs
if [ ! -d ${logdir} ]; then
	mkdir ${logdir}
fi
mv ${logfile} ${logdir}
