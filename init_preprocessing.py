import sys
import utils.copy_template as copier

dataset, subject, root = copier.parseCommandLine(sys.argv)

lifebid_root = "/N/dc2/projects/lifebid/"
out_dwi = "/derivatives/preprocess/sub-{}/dwi/"
dataset_root = {
    "stn": "O3D_STN",
    "hcp3t": "O3D_HCP3T",
    "hcp7t": "O3D_HCP7T"
}

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
    "bval_in": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-{}/dwi/run01_fliprot_aligned_trilin",
    "input": [
        lifebid_root + "2t1/predator/{}_96dirs_b2000_1p5iso/anatomy/t1.nii.gz",
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
        root + dataset_root[dataset] + out_dwi + "sub-{}_b-2000_dwi.nii.gz",
        root + dataset_root[dataset] + out_dwi + "sub-{}_dwi_brainmask.nii.gz"
    ]
}

mapping["hcp3t"] = {
    "bval_in": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP3T/sub-{}/dwi/dwi_data_b2000_aligned_trilin",
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
        root + dataset_root[dataset] + out_dwi + "sub-{}/dwi/sub-{}_b-2000_dwi.nii.gz",
        root + dataset_root[dataset] + out_dwi + "sub-{}_dwi_brainmask.nii.gz"
    ]
}

mapping["hcp7t"] = {
    "bval_in": lifebid_root + "code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP7T/sub-{}/dwi/data_b2000",
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
        root + dataset_root[dataset] + out_dwi + "sub-{}_b-2000_dwi.nii.gz",
        root + dataset_root[dataset] + out_dwi + "sub-{}_dwi_brainmask.nii.gz"
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

bvec_in = mapping[dataset]["bval_in"].format(name) + ".bvecs"
bval_in = mapping[dataset]["bval_in"].format(name) + ".bvals"
bvec_out = dataset_root[dataset] + out_dwi.format(subject) + "sub-{}_b-2000_dwi".format(subject) + ".bvecs"
bval_out = dataset_root[dataset] + out_dwi.format(subject) + "sub-{}_b-2000_dwi".format(subject) + ".bvals"

copier.copy(bval_in, bval_out, action = "copy", dummy = False)
if dataset == "hcp7t":
    copier.copy(bvec_in, bvec_out, anatomy = mask, action = "mask", dummy = False)
else:
    copier.copy(bvec_in, bvec_out, action = "copy", dummy = False)
