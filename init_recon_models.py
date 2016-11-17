import sys
import utils.copy_template as copier

dataset, subject, root = copier.parseCommandLine(sys.argv)

name = copier.subjectNameFromNumber(subject)
lifebid_root = "/N/dc2/projects/lifebid/"


files = [
    "anat/sub-{}_T1_wmmask.nii.gz",
    "dwi/sub-{}_b-2000_dwi_FA.nii.gz",
    "dwi/sub-{}_b-2000_dwi_DTI.nii.gz",
    "dwi/sub-{}_b-2000_dwi_ODF.nii.gz",
    "dwi/sub-{}_b-2000_dwi_EV.nii.gz",
    "dwi/sub-{}_b-2000_dwi_dwiresponse.txt"
]

mapping = {}
mapping["stn"] = {
    "input_dir": "/N/dc2/projects/lifebid/2t1/predator/{}_96dirs_b2000_1p5iso/fibers_new/",
    "input_files": [
        "run01_fliprot_aligned_trilin_wm.mif",
        "run01_fliprot_aligned_trilin_fa.mif",
        "run01_fliprot_aligned_trilin_dt.mif",
        "run01_fliprot_aligned_trilin_lmax8.mif",
        "run01_fliprot_aligned_trilin_ev.mif", # ?
        "run01_fliprot_aligned_trilin_response.txt" # ?
    ],
    "output": root + "O3D_STN/derivatives/recon_models/sub-{}/"
}

mapping["hcp3t"] = {
    "input_dir": "/N/dc2/projects/lifebid/2t1/HCP/{}/fibers_new/",
    "input_files": [
        "dwi_data_b2000_aligned_trilin_wm.mif",
        "dwi_data_b2000_aligned_trilin_fa.mif",
        "dwi_data_b2000_aligned_trilin_dt.mif",
        "dwi_data_b2000_aligned_trilin_lmax8.mif",
        "dwi_data_b2000_aligned_trilin_ev.mif", # ?
        "dwi_data_b2000_aligned_trilin_response.txt"
    ],
    "output": root + "O3D_HCP3T/derivatives/recon_models/sub-{}/"
}

mapping["hcp7t"] = {
    "input_dir": "/N/dc2/projects/lifebid/HCP7/{}/fibers/",
    "input_files": [
        "data_b2000_wm.mif",
        "data_b2000_fa.mif",
        "data_b2000_dt.mif",
        "data_b2000_lmax8.mif",
        "data_b2000_ev.mif", # ?
        "data_b2000_response.txt"
    ],
    "mask": lifebid_root + "HCP7/{}/diffusion_data/nodif_brain_mask.nii.gz",
    "output": root + "O3D_HCP7T/derivatives/recon_models/sub-{}/"
}

masks = [
    "_FA.nii.gz",
    "DTI.nii.gz",
    "ODF.nii.gz"
]

for i in range(len(files)):
    in_str = mapping[dataset]["input_dir"].format(name) + mapping[dataset]["input_files"][i]
    out_str = mapping[dataset]["output"].format(subject) + files[i]
    action = "copy"
    if (mapping[dataset]["input_files"][i][:-3] == "mif"):
        action = "mrconvert"

    copier.copy(in_str, out_str, action = action, dummy = False)

    if (dataset == "hcp7t" and files[i][:-10] in masks):
        mask = mapping[dataset]["mask"].format(name)
        # for ease, I am overloading the meaning of "anatomy" in the copy function
        copier.copy(out_str, out_str, anatomy = mask, action = "mask", dummy = False)
