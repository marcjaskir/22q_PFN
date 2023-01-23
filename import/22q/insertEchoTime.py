#!/bin/env python

import os
import glob
import json
import sys

ses_dir = sys.argv[1]

print('Inserting EchoTime1 and EchoTime2 fields in phasediff field map jsons...')
sub = os.path.basename(os.path.dirname(ses_dir))
ses = os.path.basename(ses_dir)

fmapsPath = os.path.join(ses_dir, 'fmap', '*phasediff.json')
fmaps = glob.glob(fmapsPath)

#substring to be removed from absolute path of functional files
for fmap in fmaps:

	# Change permissions to read/write
	os.chmod(fmap, 438)

	with open(fmap, 'r') as data_file:
		fmap_json = json.load(data_file)
	fmap_json['EchoTime1'] = 0.00471
	fmap_json['EchoTime2'] = 0.00717

	with open(fmap, 'w') as data_file:
		fmap_json = json.dump(fmap_json, data_file,indent=2)
