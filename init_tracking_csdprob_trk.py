import sys
import utils.copy_template as copier

dataset, subject, root = copier.parseCommandLine(sys.argv)

name = copier.subjectNameFromNumber(subject)
repititions = ['0' + `i` for i in range(1,10)] + ["10"]
rep_str = copier.arrToInterpolateString(repititions)
anatomy = copier.getAnatomy(root, dataset, subject)

lifebid_root = "/N/dc2/projects/lifebid/"

mapping = {}
mapping["stn"] = {
    "input": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-{}/tractography/run01_fliprot_aligned_trilin_csd_lmax8_wm_SD_PROB-NUM{}-500000.tck",
    "output": root + "O3D_STN/derivatives/tracking_csdprob_trk/sub-{}/dwi/sub-{}_dwi_var-csdprob_run-{}_tract.trk",
    "mat_in": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-{}/fe_structures/fe_structure_{}_96dirs_b2000_1p5iso_STC_run01_SD_PROB_lmax8_connNUM{}.mat",
    "mat_out": root + "O3D_STN/derivatives/tracking_csdprob_trk/sub-{}/dwi/sub-{}_dwi_var-csdproblife_run-{}_tract.trk"
}

mapping["hcp3t"] = {
    "input": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP3T/sub-{}/tractography/dwi_data_b2000_aligned_trilin_csd_lmax8_wm_SD_PROB-NUM{}-500000.tck",
    "output": root + "O3D_HCP3T/derivatives/tracking_csdprob_trk/sub-{}/dwi/sub-{}_dwi_var-csdprob_run-{}_tract.trk",
    "mat_in": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP3T/sub-{}/fe_structures/fe_structure_{}_STC_run01_SD_PROB_lmax8_connNUM{}.mat",
    "mat_out": root + "O3D_HCP3T/derivatives/tracking_csdprob_trk/sub-{}/dwi/sub-{}_dwi_var-csdproblife_run-{}_tract.trk"
}

mapping["hcp7t"] = {
    "input": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP7T/sub-{}/tractography/data_b2000_csd_lmax8_wm_SD_PROB-NUM{}-500000.tck",
    "output": root + "O3D_HCP7T/derivatives/tracking_csdprob_trk/sub-{}/dwi/sub-{}_dwi_var-csdprob_run-{}_tract.trk",
    "mat_in": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP7T/sub-{}/fe_structures/fe_structure_{}_STC_run01_SD_PROB_lmax8_connNUM{}.mat",
    "mat_out": root + "O3D_HCP7T/derivatives/tracking_csdprob_trk/sub-{}/dwi/sub-{}_dwi_var-csdproblife_run-{}_tract.trk"
}

mat_in = mapping[dataset]["mat_in"].format(name, name, rep_str)
mat_out = mapping[dataset]["mat_out"].format(subject, subject, rep_str)
input = mapping[dataset]["input"].format(name, rep_str)
output = mapping[dataset]["output"].format(subject, subject, rep_str)
copier.copy(input, output, anatomy = anatomy, action = 'tck2trk', dummy = False)
copier.copy(mat_in, mat_out, anatomy = anatomy, action = "LIFE", dummy = False)
