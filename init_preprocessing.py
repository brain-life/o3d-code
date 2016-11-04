import sys
import utils.copy_template as copier

dataset, subject, root = copier.parseCommandLine(sys.argv)

lifebid_root = "/N/dc2/projects/lifebid/"

name = copier.subjectNameFromNumber(subject)
algs = [("tens", "dtidet", "lmax2"), ("detr", "csddet", "lmax8"), ("prob", "csdprob", "lmax8")]

def getSublong(num_str):
    sublong = {"001": "pestilli_test", "002": "takemura", "003": "knk", "004": "lmperry"}
    if num_str in sublong:
        return sublong[num_str]
    else:
        return 0

mapping = {}
mapping["stn"] = {
    "input": [
        lifebid_root + "2t1/predator/{}_diffusion/anatomy/t1.nii.gz",
        lifebid_root + "2t1/anatomy/{}/mri/brainmask.mgz",
        lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-{}/dwi/run01_fliprot_aligned_trilin.nii.gz",
        lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-{}/dwi/brainMask.nii.gz"
    ],
    "params": [
        name, getSublong(subject), name, name
    ],
    "output": [
        root + "O3D_STN/derivatives/preprocess/sub-{}/anat/sub-{}_T1w.nii.gz",
        root + "O3D_STN/derivatives/preprocess/sub-{}/anat/sub-{}_T1w_brainmask.nii.gz",
        root + "O3D_STN/derivatives/preprocess/sub-{}/dwi/sub-{}_dwi.nii.gz",
        root + "O3D_STN/derivatives/preprocess/sub-{}/dwi/sub-{}_dwi_brainmask.nii.gz"
    ]
}

mapping["hcp3t"] = {
    "input": [
        lifebid_root + "2t1/HCP/{}/anatomy/T1w_acpc_dc_restore_1p25.nii.gz",
        lifebid_root + "2t1/anatomy/{}/mri/brainmask.mgz",
        lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP3T/sub-{}/dwi/dwi_data_b2000_aligned_trilin.nii.gz",
        lifebid_root + "2t1/HCP/{}/original_hcp_data/nodif_brain_mask.nii.gz"
    ],
    "params": [
        name, name, name, name
    ],
    "output": [
        root + "O3D_HCP3T/derivatives/preprocess/sub-{}/anat/sub-{}_T1w.nii.gz",
        root + "O3D_HCP3T/derivatives/preprocess/sub-{}/anat/sub-{}_T1w_brainmask.nii.gz",
        root + "O3D_HCP3T/derivatives/preprocess/sub-{}/dwi/sub-{}_dwi.nii.gz",
        root + "O3D_HCP3T/derivatives/preprocess/sub-{}/dwi/sub-{}_dwi_brainmask.nii.gz"
    ]
}

mapping["hcp7t"] = {
    "input": [
        lifebid_root + "HCP7/{}/anatomy/T1w_acpc_dc_restore.nii.gz",
        lifebid_root + "HCP7/{}/anatomy/brainmask_fs.nii.gz",
        lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP7T/sub-{}/dwi/data_b2000.nii.gz",
        lifebid_root + "HCP7/{}/diffusion_data/nodif_brain_mask.nii.gz"
    ],
    "params": [
        name, name, name, name
    ],
    "output": [
        root + "O3D_HCP7T/derivatives/preprocess/sub-{}/anat/sub-{}_T1w.nii.gz",
        root + "O3D_HCP7T/derivatives/preprocess/sub-{}/anat/sub-{}_T1w_brainmask.nii.gz",
        root + "O3D_HCP7T/derivatives/preprocess/sub-{}/dwi/sub-{}_dwi.nii.gz",
        root + "O3D_HCP7T/derivatives/preprocess/sub-{}/dwi/sub-{}_dwi_brainmask.nii.gz"
    ]
}

inputs = mapping[dataset]["input"]
params = mapping[dataset]["params"]
outputs = mapping[dataset]["output"]
copier.copy(inputs[0].format(params[0]), outputs[0].format(subject, subject), dummy = False)
action = "copy"
if inputs[1][:-3] == "mgz":
    action = "mri_convert"
copier.copy(inputs[1].format(params[1]), outputs[1].format(subject, subject), action = action, dummy = False)
copier.copy(inputs[2].format(params[2]), outputs[2].format(subject, subject), dummy = False)
copier.copy(inputs[3].format(params[3]), outputs[3].format(subject, subject), dummy = False)
