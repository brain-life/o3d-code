import sys
import utils.copy_template as copier

dataset, subject, root = copier.parseCommandLine(sys.argv)

name = copier.subjectNameFromNumber(subject)
repititions = ['0' + `i` for i in range(1,10)] + ["10"]
rep_str = copier.arrToInterpolateString(repititions)

lifebid_root = "/N/dc2/projects/lifebid/"

mapping = {}
mapping["stn"] = {
    "dtidet_input": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-{}/fe_structures/fe_structure_{}_96dirs_b2000_1p5iso_STC_run01_tensor__connNUM{}.mat",
    "csddet_input": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-{}/fe_structures/fe_structure_{}_96dirs_b2000_1p5iso_STC_run01_SD_STREAM_lmax8_connNUM{}.mat",
    "csdprob_input": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-{}/fe_structures/fe_structure_{}_96dirs_b2000_1p5iso_STC_run01_SD_PROB_lmax8_connNUM{}.mat",
    "dtidet_output": root + "O3D_STN/derivatives/life_struct/sub-{}/dwi/sub-{}_dwi_var-dtidetlife_trial-{}_life.mat",
    "csddet_output": root + "O3D_STN/derivatives/life_struct/sub-{}/dwi/sub-{}_dwi_var-csddetlife_trial-{}_life.mat",
    "csdprob_output": root + "O3D_STN/derivatives/life_struct/sub-{}/dwi/sub-{}_dwi_var-csdproblife_trial-{}_life.mat"
}

mapping["hcp3t"] = {
    "dtidet_input": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP3T/sub-{}/fe_structures/fe_structure_{}_STC_run01_tensor__connNUM{}.mat",
    "csddet_input": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP3T/sub-{}/fe_structures/fe_structure_{}_STC_run01_SD_STREAM_lmax8_connNUM{}.mat",
    "csdprob_input": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP3T/sub-{}/fe_structures/fe_structure_{}_STC_run01_SD_PROB_lmax8_connNUM{}.mat",
    "dtidet_output": root + "O3D_HCP3T/derivatives/life_struct/sub-{}/dwi/sub-{}_dwi_var-dtidetlife_trial-{}_life.mat",
    "csddet_output": root + "O3D_HCP3T/derivatives/life_struct/sub-{}/dwi/sub-{}_dwi_var-csddetlife_trial-{}_life.mat",
    "csdprob_output": root + "O3D_HCP3T/derivatives/life_struct/sub-{}/dwi/sub-{}_dwi_var-csdproblife_trial-{}_life.mat"
}

mapping["hcp7t"] = {
    "dtidet_input": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP7T/sub-{}/fe_structures/fe_structure_{}_STC_run01_tensor__connNUM{}.mat",
    "csddet_input": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP7T/sub-{}/fe_structures/fe_structure_{}_STC_run01_SD_STREAM_lmax8_connNUM{}.mat",
    "csdprob_input": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP7T/sub-{}/fe_structures/fe_structure_{}_STC_run01_SD_PROB_lmax8_connNUM{}.mat",
    "dtidet_output": root + "O3D_HCP7T/derivatives/life_struct/sub-{}/dwi/sub-{}_dwi_var-dtidetlife_trial-{}_life.mat",
    "csddet_output": root + "O3D_HCP7T/derivatives/life_struct/sub-{}/dwi/sub-{}_dwi_var-csddetlife_trial-{}_life.mat",
    "csdprob_output": root + "O3D_HCP7T/derivatives/life_struct/sub-{}/dwi/sub-{}_dwi_var-csdproblife_trial-{}_life.mat"
}

# Need script to compute AFTER-LIFE trk files, then run that here as well.
# matlab -nosplash -nodesktop -r "addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'));fe2trk /N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-FP/fe_structures/fe_structure_FP_96dirs_b2000_1p5iso_STC_run01_tensor__connNUM01.mat /N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-FP/dwi/run01_fliprot_aligned_trilin.nii.gz out.trk"
algs = ['dtidet', 'csddet', 'csdprob']
for alg in algs:
    input = mapping[dataset][alg + "_input"].format(name, name, rep_str)
    output = mapping[dataset][alg + "_output"].format(subject, subject, rep_str)
    copier.copy(input, output, dummy = False)


# in_str = mapping[dataset]["input"].format(name, rep_str)
# out_str = mapping[dataset]["output"].format(subject, subject, rep_str)
# copier.copy(in_str, out_str, dummy = False)
