import sys
import utils.copy_template as copier

dataset, subject, root = copier.parseCommandLine(sys.argv)
print("Warning, this can only be run after init_dissection_afq_trk.py has been run")
name = copier.subjectNameFromNumber(subject)
repititions = ['0' + `i` for i in range(1,10)] + ["10"]
rep_str = copier.arrToInterpolateString(repititions)
tracts = ['ATRl', 'ATRr', 'CSTl', 'CSTr', 'CCgl', 'CCgr', 'CHyl', 'CHyr', 'FMJ', 'FMI', 'IFOFl', 'IFOFr', 'ILFl', 'ILFr', 'SLFl', 'SLFr', 'UFl', 'UFr', 'ARCl', 'ARCr']
tract_str = copier.arrToInterpolateString(tracts)
anatomy = copier.getAnatomy(root, dataset, subject)

mapping = {}
mapping["stn"] = {
    "input": root + "O3D_{}/derivatives/dissection_afq_csdprob_trk/sub-{}/dwi/sub-{}_dwi_DTI_var-csdproblife_run-{}_tract_var-afq_set-{}_track.trk",
    "output": root + "O3D_{}/derivatives/dissection_afq_csdprob_tck/sub-{}/dwi/sub-{}_dwi_DTI_var-csdproblife_run-{}_tract_var-afq_set-{}_track.tck"
}

mapping["hcp3t"] = {
    "input": root + "O3D_{}/derivatives/dissection_afq_csdprob_trk/sub-{}/dwi/sub-{}_dwi_DTI_var-csdproblife_run-{}_tract_var-afq_set-{}_track.trk",
    "output": root + "O3D_{}/derivatives/dissection_afq_dtiprob_tck/sub-{}/dwi/sub-{}_dwi_DTI_var-csdproblife_run-{}_tract_var-afq_set-{}_track.tck"
}

# mapping["hcp7t"] = {
#     "input": root + "O3D_HCP7T/derivatives/tracking_csddet_trk/sub-{}/dwi/sub-{}_dwi_var-csddet-run-{}_tract.trk",
#     "output": root + "O3D_HCP7T/derivatives/tracking_csddet_tck/sub-{}/dwi/sub-{}_dwi_var-csddet-run-{}_tract.tck",
#     "anatomy": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP7T/sub-{}/dwi/data_b2000.nii.gz",
# }

# Need script to compute AFTER-LIFE trk files, then run that here as well.
# matlab -nosplash -nodesktop -r "addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'));fe2trk /N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-FP/fe_structures/fe_structure_FP_96dirs_b2000_1p5iso_STC_run01_tensor__connNUM01.mat /N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-FP/dwi/run01_fliprot_aligned_trilin.nii.gz out.trk"


in_str = mapping[dataset]["input"].format(dataset.upper(), subject, subject, rep_str, tract_str)
out_str = mapping[dataset]["output"].format(dataset.upper(), subject, subject, rep_str, tract_str)
copier.copy(in_str, out_str, anatomy = anatomy, action = "trk2tck", dummy = False)
