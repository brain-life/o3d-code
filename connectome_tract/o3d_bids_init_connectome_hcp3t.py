import sys
import o3d_bids_init_connectome_mat2csv

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

subjects = ["105115", "110411", "111312", "113619"]
repititions = ['0' + `i` for i in range(1, 10)] + ["10"]
algorithms = [("tens", "dtidet", "lmax2"), ("detr", "csddet", "lmax8"), ("prob", "csdprob", "lmax8")]

matlab_filepath = "/N/dc2/projects/lifebid/HCP/Brent/cogs610/reps_data/"
destination = ""

subnum = {}
for i in range(len(subjects)):
    subnum[subjects[i]] = '00' + `i + 5`

for subject in subjects:
    destination = "O3D_HCP3T/derivatives/connectome_tract/sub-" + subnum[subject] + "/dwi/"
    for rep in repititions:
        for alg in algorithms:
            inalg, outalg, lmax = alg
            infile = matlab_filepath + 'hcp_' + subject + '_' + inalg +'_' + lmax + '_rep' + rep + '.mat'
            outfile = destination + 'sub-' + subnum[subject] + '_dwi_variant-' + outalg + 'life_trial-' + rep
            o3d_bids_init_connectome_mat2csv.convert(infile, outfile, dummy, validate, touch)
