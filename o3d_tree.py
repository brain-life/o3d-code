#!/usr/bin/env python

import sys
from os.path import join
from subprocess import call

dataset = ['O3D_STN', 'O3D_HCP3T', 'O3D_HCP7T']

subjects = {}
subjects['O3D_STN'] = ['001', '002', '003', '004']
subjects['O3D_HCP3T'] = ['005', '006', '007', '008']
subjects['O3D_HCP7T'] = ['009', '010', '011', '012']

dir_root = '.'

files = ['README',
         'CHANGES',
         'dataset_description.json',
         'participants.csv']

derivatives = 'derivatives'

pipelines = ['hcp',
             'recon_models',
             'tracking_dtidet_trk',
             'tracking_csddet_trk',
             'tracking_csdprob_trk',
             'life_structure',
             'dissection_afq',
             'connectome_tract']

readme = 'README'

data_dir = {}
data_file = {}

data_dir['hcp'] = ['anat', 'dwi']
data_file['hcp', 'anat'] = ['_T1w.nii.gz',
                        '_T1w_brainmask.nii.gz',
                        '_T1w_dtissue.nii.gz']
data_file['hcp', 'dwi'] = ['_dwi.nii.gz',
                       '_dwi_brainmask.nii.gz',
                       '_dwi.bval',
                       '_dwi_bvec']

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

data_dir['tracking_dtidet_trk'] = ['dwi']
data_file['tracking_dtidet_trk', 'dwi'] = \
    ['_b-2000_dwi_ODF_variant-csddet_trial_tract.trk',
     '_b-2000_dwi_ODF_variant-csddetlife_trial_tract.trk']

data_dir['tracking_csdprob_trk'] = ['dwi']
data_file['tracking_csdprob_trk', 'dwi'] = \
    ['_b-2000_dwi_ODF_variant-csdprob_trial_tract.trk',
     '_b-2000_dwi_ODF_variant-csdproblife_trial_tract.trk']

data_dir['life_structure'] = ['dwi']
data_file['life_structure', 'dwi'] = []

data_dir['dissection_afq'] = ['dwi']
data_file['dissection_afq', 'dwi'] = []

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
