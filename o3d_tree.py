#!/usr/bin/env python

import sys
from os.path import join, isfile
from subprocess import call

def checkExists(path):
    if isfile(path):
        return 0
    else:
        print "Missing: " + path


def main(dir_root, ss, ds):

    dataset = ['O3D_STN', 'O3D_HCP3T', 'O3D_HCP7T']

    subjects = {}
    subjects['O3D_STN'] = ['0001', '0002', '0003', '0004']
    subjects['O3D_HCP3T'] = ['0005', '0006', '0007', '0008']
    subjects['O3D_HCP7T'] = ['0009', '0010', '0011', '0012']

    files = ['README',
             'CHANGES',
             'dataset_description.json',
             'participants.csv']

    derivatives = 'derivatives'

    pipelines = ['preprocess',
#                 'freesurfer',
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
#                                       '_T1w_dtissue.nii.gz',
                                       '_T1w_brainmask.nii.gz']
    data_file['preprocess', 'dwi'] = ['_b-2000_dwi.nii.gz',
                           '_dwi_brainmask.nii.gz',
                           '_b-2000_dwi.bvals',
                           '_b-2000_dwi.bvecs']

#    data_dir['freesurfer'] = ['anat']
#    data_file['freesurfer', 'anat'] = ['_parc-wm_T1w.nii.gz',
#                                       '_aparc_aseg_T1w.nii.gz',
#                                       '_ribbon_T1w.nii.gz']

    data_dir['recon_models'] = ['anat', 'dwi']
    data_file['recon_models', 'anat'] = ['_T1_wmmask.nii.gz']
    data_file['recon_models', 'dwi'] = ['_b-2000_dwi_FA.nii.gz',
                                        '_b-2000_dwi_DTI.nii.gz',
                                        '_b-2000_dwi_ODF.nii.gz',
                                        '_b-2000_dwi_dwiresponse.txt']

    data_dir['tracking_dtidet_trk'] = ['dwi']
    data_file['tracking_dtidet_trk', 'dwi'] = \
        ['_dwi_var-dtidet_run-0{}_tract.trk'.format(i+1) for i in range(9)] + ['_dwi_var-dtidet_run-10_tract.trk'] +\
        ['_dwi_var-dtidetlife_run-0{}_tract.trk'.format(i+1) for i in range(9)] + ['_dwi_var-dtidetlife_run-10_tract.trk']

    data_dir['tracking_csddet_trk'] = ['dwi']
    data_file['tracking_csddet_trk', 'dwi'] = \
        ['_dwi_var-csddet_run-0{}_tract.trk'.format(i+1) for i in range(9)] + ['_dwi_var-csddet_run-10_tract.trk'] +\
        ['_dwi_var-csddetlife_run-0{}_tract.trk'.format(i+1) for i in range(9)] + ['_dwi_var-csddetlife_run-10_tract.trk']

    data_dir['tracking_csdprob_trk'] = ['dwi']
    data_file['tracking_csdprob_trk', 'dwi'] = \
        ['_dwi_var-csdprob_run-0{}_tract.trk'.format(i+1) for i in range(9)] + ['_dwi_var-csdprob_run-10_tract.trk'] +\
        ['_dwi_var-csdproblife_run-0{}_tract.trk'.format(i+1) for i in range(9)] + ['_dwi_var-csdproblife_run-10_tract.trk']

    data_dir['tracking_dtidet_tck'] = ['dwi']
    data_file['tracking_dtidet_tck', 'dwi'] = \
        ['_dwi_var-dtidet_run-0{}_tract.tck'.format(i+1) for i in range(9)] + ['_dwi_var-dtidet_run-10_tract.tck'] +\
        ['_dwi_var-dtidetlife_run-0{}_tract.tck'.format(i+1) for i in range(9)] + ['_dwi_var-dtidetlife_run-10_tract.tck']

    data_dir['tracking_csddet_tck'] = ['dwi']
    data_file['tracking_csddet_tck', 'dwi'] = \
        ['_dwi_var-csddet_run-0{}_tract.tck'.format(i+1) for i in range(9)] + ['_dwi_var-csddet_run-10_tract.tck'] +\
        ['_dwi_var-csddetlife_run-0{}_tract.tck'.format(i+1) for i in range(9)] + ['_dwi_var-csddetlife_run-10_tract.tck']

    data_dir['tracking_csdprob_tck'] = ['dwi']
    data_file['tracking_csdprob_tck', 'dwi'] = \
        ['_dwi_var-csdprob_run-0{}_tract.tck'.format(i+1) for i in range(9)] + ['_dwi_var-csdprob_run-10_tract.tck'] +\
        ['_dwi_var-csdproblife_run-0{}_tract.tck'.format(i+1) for i in range(9)] + ['_dwi_var-csdproblife_run-10_tract.tck']

    data_dir['life_struct'] = ['dwi']
    data_file['life_struct', 'dwi'] = []

    tracts = ['ATRl', 'ATRr', 'CSTl', 'CSTr', 'CCgl', 'CCgr', 'CHyl', 'CHyr', 'FMJ', 'FMI', 'IFOFl', 'IFOFr', 'ILFl', 'ILFr', 'SLFl', 'SLFr', 'UFl', 'UFr', 'ARCl', 'ARCr']
    algs = ['csddetlife', 'dtidetlife', 'csdproblife']

    data_dir['dissection_afq_tck'] = ['dwi']
    data_file['dissection_afq_tck', 'dwi'] = \
        ['_dwi_DTI_var-{}_run-{}_tract_var-afq_set-{}_tract.tck'.format(a, i+1, t) for a in algs for i in range(10) for t in tracts]

    data_dir['dissection_afq_trk'] = ['dwi']
    data_file['dissection_afq_trk', 'dwi'] = \
        ['_dwi_DTI_var-{}_run-{}_tract_var-afq_set-{}_tract.trk'.format(a, i+1, t) for a in algs for i in range(10) for t in tracts]

    data_dir['connectome_tract'] = ['dwi']
    data_file['connectome_tract', 'dwi'] =\
        ['_dwi_DTI_var-dtidetlife_run-{}_tract_connectome.csv'.format(i+1) for i in range(10)] +\
        ['_dwi_DTI_var-csddetlife_run-{}_tract_connectome.csv'.format(i+1) for i in range(10)] +\
        ['_dwi_DTI_var-csdproblife_run-{}_tract_connectome.csv'.format(i+1) for i in range(10)]


    dir_0 = join(dir_root, ds)
    for f in files:
        filename = join(dir_0, f)
        checkExists(filename)
    dir_1 = join(dir_0, derivatives)
    for pl in pipelines:
        dir_2 = join(dir_1, pl)
        dir_3 = join(dir_2, 'sub-' + ss)
        for dd in data_dir[pl]:
            dir_4 = join(dir_3, dd)
            for df in data_file[pl, dd]:
                filename = join(dir_4, 'sub-' + ss + df)
                checkExists(filename)

if __name__ == "__main__":
    root = '.'
    if len(sys.argv) > 1:
        root = sys.argv[1]
    sub = 'all'
    if len(sys.argv) > 2:
        sub = sys.argv[2]
    dat = 'all'
    if len(sys.argv) > 3:
        dat = sys.argv[3]

    main(root, sub, dat)
