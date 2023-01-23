## Import raw 22q imaging data from Flywheel to bbl_22q project (/cbica/projects/bbl_22q) on the Cubic cluster

### Requirements
Install Miniconda (instructions: https://pennlinc.github.io/docs/cubic)
Install the Flywheel CLI within a conda environment called "flywheel" (instructions: https://pennlinc.github.io/docs/flywheel)

### Usage
Activate the flywheel conda environment and run wrapper_download_convert.py

Run qc/assess_bids_completeness_22q.sh to create:
- A completeness report for each subject/session (by scan type)
- A list of subjects with the following data for at least 1 session: T1, fmaps, rest, idemo
NOTE: This just checks for the existence of relevant files/directories to constrain which subjects go through fmriprep - more extensive QC is performed later

### Pipeline overview

wrapper_download_convert.py
- Submits download_convert.sh as a job for subjects/sessions without a dicom directory

download_convert.sh
- Calls download.sh
- Calls convert.sh
- Soves log file to a "logs" subdirectory in the raw BIDS directory for that subject/session

download.sh
- Calls download.py
- Uncompresses DICOM zip files

download.py
- Using the Flywheel CLI, download DICOMs for that subject/seession

convert.sh
- Run heudiconv to convert DICOMs to Niftis and organize data according to BIDS (heuristic file: heuristic.py)
- Calls correct_fmap_fnames.sh
- Calls insertIntendedFor.py
- Calls insertEchoTime.py

correct_fmap_fnames.sh
- Correct field map file names according to BIDS

insertIntendedFor.py
- Insert IntendedFor fields in field map jsons according to BIDS

insertEchoTime.py
- Insert EchoTime1 and EchoTime2 fields in phasediff field map jsons according to BIDS

### Code location on Cubic
/cbica/projects/bbl_22q/data/scripts/import/imaging
