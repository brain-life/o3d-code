README - Preprocessing

The preprocessing pipeline aligns the anatomy to the anterior-,
posterior-commissure plane, segments the brain cortical and
subcortical structures, aligns the dMRI data to the aligned anatomy
and reorients the BVECS and BVALS to account for any difference in
dMRI data orientation. In practice the preprocessing pipeline changes the
HCP-processed data only minimally. The pipeline assures that data from
the three data source (HCP3T, HCP7T and STN) underwent the same
processing and normalization steps before tractography, tract
segmentation and connection matrices were constructed.

Open source code reproducing the steps of preprocessing are available here:
- https://github.com/brain-life/app-dtiinit
- https://github.com/brain-life/app-autoalignacpc
- https://github.com/brain-life/app-freesurfer
