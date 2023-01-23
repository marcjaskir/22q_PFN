#!/bin/bash

sub=${1}
ses=${2}
dicomdir=${3}

# make dicom dir
mkdir -p ${dicomdir}

# download from flywheel
./download.py ${sub} ${ses} ${dicomdir}

# unzip
for files in ${dicomdir}/*.dicom.zip; do
	unzip -q ${files} -d ${dicomdir}
done

# remove .zip files
rm ${dicomdir}/*.dicom.zip
