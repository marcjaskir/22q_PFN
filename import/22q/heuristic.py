'''
Heuristic to curate the 22Q_812481 project.
Katja Zoner
Updated: 10/06/2022 by Marc Jaskir
'''

import os

##################### Create keys for each acquisition type ####################

def create_key(template, outtype=('nii.gz',), annotation_classes=None):
	if template is None or not template:
		raise ValueError('Template must be a valid format string')
	return template, outtype, annotation_classes

# Structural scans
t1w = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_T1w')

# fMRI scans
rest_bold_124 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-rest_acq-singleband_bold')
demo = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-idemo_bold')
jolo = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-jolo_bold')

# Field maps
b0_mag = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_magnitude{item}')
b0_phase = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_phase{item}')
b0_phasediff = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_phasediff')

############################ Define heuristic rules ############################

def infotodict(seqinfo):

	# Info dictionary to map series_id's to correct create_key key
	info = {t1w: [], rest_bold_124: [],  demo: [], jolo: [], b0_mag: [], b0_phase: [], b0_phasediff: []}

	def get_latest_series(key, s):
		info[key].append(s.series_id)

	for s in seqinfo:
		protocol = s.protocol_name.lower()

		# Structural scans
		if "mprage" in protocol and "nav" not in protocol and "MOSAIC" not in s.image_type:
			get_latest_series(t1w, s)

		# fMRI scans
		elif "idemo" in protocol:
			get_latest_series(demo, s)
		elif "restbold" in protocol:
			get_latest_series(rest_bold_124, s)
		elif "jolo" in protocol:
			get_latest_series(jolo, s)

		# Fieldmap scans
		elif "b0map" in protocol and "M" in s.image_type:
		
			get_latest_series(b0_mag, s)

		elif "b0map" in protocol and "P" in s.image_type:

			if "v3" in protocol:
				info[b0_phase].append(s.series_id)
				get_latest_series(b0_phase, s)
			else:
				info[b0_phasediff].append(s.series_id)
				get_latest_series(b0_phasediff, s)

		else:
			print("Series not recognized!: ", s.protocol_name, s.dcm_dir_name)

	return info

################## Hardcode required params in MetadataExtras ##################
MetadataExtras = {    
	b0_phasediff: {
		"EchoTime1": 0.00471,
		"EchoTime2": 0.00717
	}
}

IntendedFor = {
	b0_phase: [
		'{session}/func/sub-{subject}_{session}_task-rest_acq-singleband_bold.nii.gz',
		'{session}/func/sub-{subject}_{session}_task-jolo_bold.nii.gz',
		'{session}/func/sub-{subject}_{session}_task-idemo_bold.nii.gz',
	],
	b0_phasediff: [
		'{session}/func/sub-{subject}_{session}_task-rest_acq-singleband_bold.nii.gz',
		'{session}/func/sub-{subject}_{session}_task-idemo_bold.nii.gz',
	],
	b0_mag: [
		'{session}/func/sub-{subject}_{session}_task-rest_acq-singleband_bold.nii.gz',
		'{session}/func/sub-{subject}_{session}_task-jolo_bold.nii.gz',
		'{session}/func/sub-{subject}_{session}_task-idemo_bold.nii.gz',
	]
}

