import o3d_bids_init_connectome_mat2csv
import sys

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
repititions = ['0' + `i` for i in range(10)] + ["10"]
# lmax = ['lmax' + `i` for i in range(2, 14, 2)]
lmax = ['lmax2']

matlab_filepath = ""
destination = ""

subnum = {}
for i in range(len(subjects)):
    if i + 9 < 10:
        subnum[subjects[i]] = '00' + `i + 9`
    else:
        subnum[subjects[i]] = '0' + `i + 9`
        
for subject in subjects:
    destination = "O3D_HCP7T/derivatives/connectome_tract/sub-" + subnum[subject] + "/dwi/"
    for rep in repititions:
        for l in lmax:
            infile = matlab_filepath + 'stn_' + subject + '_tens_' + l + '_rep' + rep + '.mat'
            outfile = destination + 'sub-' + subnum[subject] + '_dwi_variant-dtidetlife_trial-' + rep
            o3d_bids_init_connectome_mat2csv.convert(infile, outfile, dummy, validate, touch)
