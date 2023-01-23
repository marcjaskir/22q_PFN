#!/bin/env python

import sys
import flywheel

# parse args
sub = sys.argv[1]
ses = sys.argv[2]
outpath = sys.argv[3]

fw = flywheel.Client()
session = fw.lookup('/'.join(['bbl', '22Q_812481', sub, ses]))

# Iterate over acquisitions
for acquisitions in session.acquisitions():

	# Download dicoms
	for files in range(len(acquisitions.files)):
		file=acquisitions.files[files]
		if file.type == 'dicom':
			acquisitions.download_file(file.name, outpath + '/' + file.name)

