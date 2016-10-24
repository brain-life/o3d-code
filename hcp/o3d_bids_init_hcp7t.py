import sys
from subprocess import call
import os

dummy = False
validate = False
touch = False
if len(sys.argv) > 1:
    if sys.argv[1] == "--dummy":
        dummy = True
    if sys.argv[1] == "--validate":
        validate = True
    if sys.argv[1] == "--touch":
        touch = True

subjects = ["108323", "109123", "131217", "910241"]

filepath_t1 = "/N/dc2/projects/lifebid/HCP7/"
filepath_bm = "/N/dc2/projects/lifebid/HCP7/"
filepath_dwi = "/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/HCP7T/"
filepath_dwi_bm = "/N/dc2/projects/lifebid/HCP7"

dwi_types = [".nii.gz", ".bval", ".bvec"]

destination = ""

subnum = {}
for i in range(len(subjects)):
    subnum[subjects[i]] = '00' + `i + 5`

for subject in subjects:
    destination = "O3D_HCP7T/derivatives/hcp/sub-" + subnum[subject] + "/"
    infile_t1 = filepath_t1 + subject + "/anatomy/T1w_acpc_dc_restore.nii.gz"
    outfile_t1 = destination + "anat/sub-" +  subnum[subject] + "_T1w.nii.gz"

    infile_bm = filepath_bm + subject + "/anatomy/brainmask_fs.nii.gz"
    outfile_bm = destination + "anat/sub-" + subnum[subject] + "_T1w_brainmask.nii.gz"

    infile_dwi = filepath_dwi + "sub-" + subject + "/dwi/data_b2000"
    outfile_dwi = destination + "dwi/sub-" + subnum[subject] + "_dwi"

    infile_dwi_bm = filepath_dwi_bm + subject + "/diffusion_data/nodif_brain_mask.nii.gz"
    outfile_dwi_bm = destination + "dwi/sub-" + subnum[subject] + "_dwi_brainmask.nii.gz"

    if (dummy):
        print "cp " + infile_t1 + " " + outfile_t1
        print "cp " + infile_bm + " " + outfile_bm
        print "cp " + infile_dwi_bm + " " + outfile_dwi_bm
        for t in dwi_types:
            print "cp " + infile_dwi + t + " " + outfile_dwi + t
    elif (touch):
        call(["touch", outfile_t1])
        call(["touch", outfile_bm])
        call(["touch", outfile_dwi_bm])
        for t in dwi_types:
            call(["touch", outfile_dwi + t])
    else:
        call(["cp", infile_t1, outfile_t1])
        call(["cp", infile_bm, outfile_bm])
        call(["cp", infile_dwi_bm, outfile_dwi_bm])
        for t in dwi_types:
            call(["cp", infile_dwi + t, outfile_dwi + t])
        if (validate):
            if (os.path.isfile(outfile_t1)):
                print outfile_t1 + " --- validated"
            else:
                print outfile_t1 + " --- not valid!"
