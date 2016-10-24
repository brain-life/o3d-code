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
repititions = ['0' + `i` for i in range(1, 10)] + ["10"]
algorithms = [("tens", "dtidet", "lmax2"), ("detr", "csddet", "lmax8"), ("prob", "csdprob", "lmax8")]

matlab_filepath = "/N/dc2/projects/lifebid/HCP/Brent/cogs610/7t_reps_data/"
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
        for alg in algorithms:
            inalg, outalg, lmax = alg
            infile = matlab_filepath + '7T_' + subject + '_' + inalg +'_' + lmax + '_rep' + rep + '.mat'
            outfile = destination + 'sub-' + subnum[subject] + '_dwi_variant-' + outalg + 'life_trial-' + rep
            o3d_bids_init_connectome_mat2csv.convert(infile, outfile, dummy, validate, touch)
