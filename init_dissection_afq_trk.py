import sys
import utils.copy_template as copier

dataset, subject, root = copier.parseCommandLine(sys.argv)

name = copier.subjectNameFromNumber(subject)
repititions = ['0' + `i` for i in range(1,10)] + ["10"]
rep_str = copier.arrToInterpolateString(repititions)

lifebid_root = "/N/dc2/projects/lifebid/"

mapping = {}
mapping["stn"] = {
    "mat_in": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/Results/ETC_Dec2015/Single_TC/fe_structure_{}_96dirs_b2000_1p5iso_STC_run01_500000_tensor__connNUM{}_TRACTS.mat",
    "anatomy": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-{}/dwi/run01_fliprot_aligned_trilin.nii.gz",
    "mat_out": root + "O3D_STN/derivatives/dissection_afq_trk/dwi/sub-{}_dwi_DTI_variant_dtidetlife_trial-{}_tract"
}

mapping["hcp3t"] = {
    "mat_in": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/Results/ETC_Dec2015/Single_TC/fe_structure_{}_stc_run01_500000_tensor__connNUM{}_TRACTS.mat",
    "anatomy": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP3T/sub-{}/dwi/dwi_data_b2000_aligned_trilin.nii.gz",
    "mat_out": root + "O3D_STN/derivatives/dissection_afq_trk/dwi/sub-{}_dwi_DTI_variant_dtidetlife_trial-{}_tract"
}

# mapping["hcp7t"] = {
#     "mat_in": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP7T/sub-{}/fe_structures/fe_structure_{}_STC_run01_SD_STREAM_lmax8_connNUM{}.mat",
#     "anatomy": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP7T/sub-{}/dwi/data_b2000.nii.gz",
#     "mat_out": root + "O3D_HCP7T/derivatives/tracking_csddet_trk/sub-{}/dwi/sub-{}_dwi_variant-csddetlife_trial-{}_tract.trk"
# }

if dataset == "hcp7t":
    print "Cannot run for hcp7t yet, these files don't exist"
    sys.exit()

# Need script to compute AFTER-LIFE trk files, then run that here as well.
# matlab -nosplash -nodesktop -r "addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'));fe2trk /N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-FP/fe_structures/fe_structure_FP_96dirs_b2000_1p5iso_STC_run01_tensor__connNUM01.mat /N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-FP/dwi/run01_fliprot_aligned_trilin.nii.gz out.trk"

mat_in = mapping[dataset]["mat_in"].format(name, name, rep_str)
anatomy = mapping[dataset]["anatomy"].format(name)
mat_out = mapping[dataset]["mat_out"].format(subject, subject, rep_str)
copier.copy(mat_in, mat_out, anatomy = anatomy, action = "afq2trk", dummy = False)

# in_str = mapping[dataset]["input"].format(name, rep_str)
# out_str = mapping[dataset]["output"].format(subject, subject, rep_str)
# copier.copy(in_str, out_str, dummy = False)
