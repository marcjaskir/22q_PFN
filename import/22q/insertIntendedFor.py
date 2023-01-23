#!/bin/env python

import os
import glob
import json
import sys

ses_dir = sys.argv[1]

print('Inserting IntendedFor fields in field map jsons...')
sub = os.path.basename(os.path.dirname(ses_dir))
ses = os.path.basename(ses_dir)

fmapsPath = os.path.join(ses_dir, 'fmap', '*.json')
fmaps = glob.glob(fmapsPath)
funcsPath = os.path.join(ses_dir, 'func', '*.nii.gz')
funcs = glob.glob(funcsPath)

#substring to be removed from absolute path of functional files
pathToRemove = '../../../raw/' + sub + '/'
funcs = list(map(lambda x: x.replace(pathToRemove, ''), funcs))
for fmap in fmaps:

	# Change permissions to read/write
	os.chmod(fmap, 438)

	with open(fmap, 'r') as data_file:
		fmap_json = json.load(data_file)
	fmap_json['IntendedFor'] = funcs

	with open(fmap, 'w') as data_file:
		fmap_json = json.dump(fmap_json, data_file,indent=2)
