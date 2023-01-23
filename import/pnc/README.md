## Import preprocessed PNC imaging data from home directory (/cbica/home/jaskirm/) to bbl_22q project (/cbica/projects/bbl_22q) on the Cubic cluster

### Context
PNC preprocessed imaging data is stored here as a datalad dataset: /cbica/projects/RBC/production/PNC/

### Requirements
Install datalad and dependencies, including git annex (instructions: https://handbook.datalad.org/en/latest/intro/installation.html)
Clone the datalad repo to a subdirectory within home directory. Using fmriprep derivatives as an example,
```
mkdir -p /cbica/home/jaskirm/comp_space/22q/pnc_fmriprep_outputs
cd /cbica/home/jaskirm/comp_space/22q/pnc_fmriprep_outputs
datalad clone ria+file:///cbica/projects/RBC/production/PNC/fmriprep/output_ria#~data .
datalad get /cbica/home/jaskirm/comp_space/22q/pnc_fmriprep_outputs
```

### Usage
Run qsub_rsync_pnc_freesurfer_derivatives.sh to import fmriprep outputs
Run qsub_rsync_pnc_xcpd_derivatives.sh to import XCPD outputs
Run qc/assess_xcpd_completeness.sh to create a list of subjects with the following XCP-D-prepreocessed data for at least 1 session: T1, fmaps, rest, idemo

### Code location on Cubic
/cbica/projects/bbl_22q/data/scripts/import/pnc_imaging
