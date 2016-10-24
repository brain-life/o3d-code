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

subjects = ["FP", "HT", "KK", "MP"]
sublong = {"FP": "pestilli_test", "HT": "takemura", "KK": "knk", "MP": "lmperry"}

filepath_t1 = "/N/dc2/projects/lifebid/2t1/predator/"
filepath_bm = "/N/dc2/projects/lifebid/2t1/anatomy/"
filepath_dwi = "/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/"
filepath_dwi_bm = "/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/"

dwi_types = [".nii.gz", ".bval", ".bvec"]

destination = ""

subnum = {}
for i in range(len(subjects)):
    subnum[subjects[i]] = '00' + `i + 1`

if (not dummy and not touch):
    call(['module', 'load', 'freesurfer'])
for subject in subjects:
    destination = "O3D_STN/derivatives/hcp/sub-" + subnum[subject] + "/"
    infile_t1 = filepath_t1 + subject + "_diffusion/anatomy/t1.nii.gz"
    outfile_t1 = destination + "anat/sub-" +  subnum[subject] + "_T1w.nii.gz"

    infile_bm = filepath_bm + sublong[subject] + "/mri/brainmask.mgz"
    outfile_bm = destination + "anat/sub-" + subnum[subject] + "_T1w_brainmask.nii.gz"

    infile_dwi = filepath_dwi + "sub-" + subject + "/dwi/run01_fliprot_aligned_trilin"
    outfile_dwi = destination + "dwi/sub-" + subnum[subject] + "_dwi"

    infile_dwi_bm = filepath_dwi_bm + "sub-" + subject + "/dwi/brainMask.nii.gz"
    outfile_dwi_bm = destination + "dwi/sub-" + subnum[subject] + "_dwi_brainmask.nii.gz"

    if (dummy):
        print "cp " + infile_t1 + " " + outfile_t1
        print "mri_convert -it mgz -ot nii " + infile_bm + " " + outfile_bm
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
        call(["mri_convert", "-it mgz", "-ot nii", infile_bm, outfile_bm])
        call(["cp", infile_dwi_bm, outfile_dwi_bm])
        for t in dwi_types:
            call(["cp", infile_dwi + t, outfile_dwi + t])
        if (validate):
            if (os.path.isfile(outfile_t1)):
                print outfile_t1 + " --- validated"
            else:
                print outfile_t1 + " --- not valid!"
