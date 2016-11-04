import sys
import utils.copy_template as copier

dataset, subject, root = copier.parseCommandLine(sys.argv)
print("Warning, this can only be run after init_tracking_csdprob_trk.py has been run")
name = copier.subjectNameFromNumber(subject)
repititions = ['0' + `i` for i in range(1,10)] + ["10"]
rep_str = copier.arrToInterpolateString(repititions)

lifebid_root = "/N/dc2/projects/lifebid/"

mapping = {}
mapping["stn"] = {
    "input": root + "O3D_STN/derivatives/tracking_csdprob_trk/sub-{}/dwi/sub-{}_dwi_variant-csdprob-trial-{}_tract.trk",
    "output": root + "O3D_STN/derivatives/tracking_csdprob_tck/sub-{}/dwi/sub-{}_dwi_variant-csdprob-trial-{}_tract.tck",
    "anatomy": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-{}/dwi/run01_fliprot_aligned_trilin.nii.gz",
}

mapping["hcp3t"] = {
    "input": root + "O3D_HCP3T/derivatives/tracking_csdprob_trk/sub-{}/dwi/sub-{}_dwi_variant-csdprob-trial-{}_tract.trk",
    "output": root + "O3D_HCP3T/derivatives/tracking_csdprob_tck/sub-{}/dwi/sub-{}_dwi_variant-csdprob-trial-{}_tract.tck",
    "anatomy": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP3T/sub-{}/dwi/dwi_data_b2000_aligned_trilin.nii.gz",
}

mapping["hcp7t"] = {
    "input": root + "O3D_HCP7T/derivatives/tracking_csdprob_trk/sub-{}/dwi/sub-{}_dwi_variant-csdprob-trial-{}_tract.trk",
    "output": root + "O3D_HCP7T/derivatives/tracking_csdprob_tck/sub-{}/dwi/sub-{}_dwi_variant-csdprob-trial-{}_tract.tck",
    "anatomy": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP7T/sub-{}/dwi/data_b2000.nii.gz",
}

# Need script to compute AFTER-LIFE trk files, then run that here as well.
# matlab -nosplash -nodesktop -r "addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'));fe2trk /N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-FP/fe_structures/fe_structure_FP_96dirs_b2000_1p5iso_STC_run01_tensor__connNUM01.mat /N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-FP/dwi/run01_fliprot_aligned_trilin.nii.gz out.trk"


in_str = mapping[dataset]["input"].format(name, rep_str)
out_str = mapping[dataset]["output"].format(subject, subject, rep_str)
anatomy = mapping[dataset]["anatomy"].format(name)
copier.copy(in_str, out_str, anatomy = anatomy, action = "trk2tck", dummy = False)
