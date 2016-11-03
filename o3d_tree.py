#!/usr/bin/env python

import sys
from os.path import join
from subprocess import call

def main(dir_root):

    dataset = ['O3D_STN', 'O3D_HCP3T', 'O3D_HCP7T']

    subjects = {}
    subjects['O3D_STN'] = ['001', '002', '003', '004']
    subjects['O3D_HCP3T'] = ['005', '006', '007', '008']
    subjects['O3D_HCP7T'] = ['009', '010', '011', '012']

    files = ['README',
             'CHANGES',
             'dataset_description.json',
             'participants.csv']

    derivatives = 'derivatives'

    pipelines = ['preprocess',
                 'freesurfer',
                 'recon_models',
                 'tracking_dtidet_trk',
                 'tracking_csddet_trk',
                 'tracking_csdprob_trk',
                 'tracking_dtidet_tck',
                 'tracking_csddet_tck',
                 'tracking_csdprob_tck',
                 'life_struct',
                 'dissection_afq_trk',
                 'dissection_afq_tck',
                 'connectome_tract']

    readme = 'README'

    data_dir = {}
    data_file = {}

    data_dir['preprocess'] = ['anat', 'dwi']
    data_file['preprocess', 'anat'] = ['_T1w.nii.gz',
                            '_T1w_brainmask.nii.gz',
                            '_T1w_dtissue.nii.gz']
    data_file['preprocess', 'dwi'] = ['_dwi.nii.gz',
                           '_dwi_brainmask.nii.gz',
                           '_dwi.bval',
                           '_dwi_bvec']

    data_dir['freesurfer'] = ['anat']
    data_file['freesurfer', 'anat'] = ['_parc-wm_T1w.nii.gz',
                                       '_aparc_aseg_T1w.nii.gz',
                                       '_ribbon_T1w.nii.gz']

    data_dir['recon_models'] = ['anat', 'dwi']
    data_file['recon_models', 'anat'] = ['_T1w_wmmask.nii.gz']
    data_file['recon_models', 'dwi'] = ['_dwi_b-2000_dwi.nii.gz',
                                        '_dwi_b-2000_dwi.bval',
                                        '_dwi_b-2000_dwi.bvec',
                                        '_dwi_b-2000_dwi_FA.nii.gz',
                                        '_dwi_b-2000_dwi_MD.nii.gz',
                                        '_dwi_b-2000_dwi_DTI.nii.gz',
                                        '_dwi_b-2000_dwi_ODF.nii.gz',
                                        '_dwi_b-2000_dwi_dwiresponse.txt']

    data_dir['tracking_dtidet_trk'] = ['dwi']
    data_file['tracking_dtidet_trk', 'dwi'] = \
        ['_b-2000_dwi_ODF_variant-dtidet_trial_tract.trk',
         '_b-2000_dwi_ODF_variant-dtidetlife_trial_tract.trk']

    data_dir['tracking_csddet_trk'] = ['dwi']
    data_file['tracking_csddet_trk', 'dwi'] = \
        ['_b-2000_dwi_ODF_variant-csddet_trial_tract.trk',
         '_b-2000_dwi_ODF_variant-csddetlife_trial_tract.trk']

    data_dir['tracking_csdprob_trk'] = ['dwi']
    data_file['tracking_csdprob_trk', 'dwi'] = \
        ['_b-2000_dwi_ODF_variant-csdprob_trial_tract.trk',
         '_b-2000_dwi_ODF_variant-csdproblife_trial_tract.trk']

    data_dir['tracking_dtidet_tck'] = ['dwi']
    data_file['tracking_dtidet_tck', 'dwi'] = \
        ['_b-2000_dwi_ODF_variant-dtidet_trial_tract.tck',
         '_b-2000_dwi_ODF_variant-dtidetlife_trial_tract.tck']

    data_dir['tracking_csddet_tck'] = ['dwi']
    data_file['tracking_csddet_tck', 'dwi'] = \
        ['_b-2000_dwi_ODF_variant-csddet_trial_tract.tck',
         '_b-2000_dwi_ODF_variant-csddetlife_trial_tract.tck']

    data_dir['tracking_csdprob_tck'] = ['dwi']
    data_file['tracking_csdprob_tck', 'dwi'] = \
        ['_b-2000_dwi_ODF_variant-csdprob_trial_tract.tck',
         '_b-2000_dwi_ODF_variant-csdproblife_trial_tract.tck']

    data_dir['life_struct'] = ['dwi']
    data_file['life_struct', 'dwi'] = []

    data_dir['dissection_afq_tck'] = ['dwi']
    data_file['dissection_afq_tck', 'dwi'] = []

    data_dir['dissection_afq_trk'] = ['dwi']
    data_file['dissection_afq_trk', 'dwi'] = []

    data_dir['connectome_tract'] = ['dwi']
    data_file['connectome_tract', 'dwi'] = []


    for ds in dataset:
        dir_0 = join(dir_root, ds)
        call(['mkdir', dir_0])
        for f in files:
            filename = join(dir_0, f)
            call(["touch", filename])
        dir_1 = join(dir_0, derivatives)
        call(["mkdir", dir_1])
        for pl in pipelines:
            dir_2 = join(dir_1, pl)
            call(["mkdir", dir_2])
            call(["touch", join(dir_2, readme)])
            for  ss in subjects[ds]:
                dir_3 = join(dir_2, 'sub-' + ss)
                call(['mkdir', dir_3])
                for dd in data_dir[pl]:
                    dir_4 = join(dir_3, dd)
                    call(["mkdir", dir_4])
                    for df in data_file[pl, dd]:
                        filename = join(dir_4, 'sub-' + ss + df)
                        call(["touch", filename])

if __name__ == "__main__":
    root = '.'
    if len(sys.argv) > 1:
        root = sys.argv[1]
    main(root)
