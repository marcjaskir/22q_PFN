#!/bin/env python

# script that will look for un-uploaded subjects in flywheel
# it will then submit jobs to download the subjects, extract dicoms
# and convert to bids format

# make sure that you are in the flywheel env

project_name = '22Q_812481'

import flywheel
import os
import subprocess
from datetime import datetime

source_dir = '../../../source'
raw_dir = '../../../raw'

# initialize fw and identify project
fw = flywheel.Client()
project = fw.lookup('/'.join(['bbl', project_name]))

# loop over participants in flywheel
for subject in project.subjects():
	for session in subject.sessions():
		if (not os.path.isdir(os.path.join(raw_dir, 'sub-' + subject.label, 'ses-' + session.label))):
			if (os.path.isdir(os.path.join(source_dir, 'sub-' + subject.label, 'ses-' + session.label, 'dicom'))):
				print('ERROR: ' + subject.label + ' - ' + session.label + ' has a dicom directory')
				exit()
			else:
				print('Downloading and converting sub-' + subject.label + '/ses-' + session.label)
				logfile = os.path.join(os.getcwd(), 'sub-' + subject.label +
					'_ses-' + session.label + '_' +
					datetime.today().strftime("%d-%m-%Y-%H-%M-%S") +
					'_download_convert.o')
				subprocess.run(['qsub -cwd -j y -o ' +
					logfile + ' download_convert.sh ' +
					subject.label + ' ' + session.label + ' ' + logfile], shell=True)

