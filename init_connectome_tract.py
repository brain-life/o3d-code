import sys
import utils.copy_template as copier

dataset = ""
subject = ""
if len(sys.argv) > 2:
    dataset = sys.argv[1]
    subject = sys.argv[2]
else:
    print("Script takes 2 arguments")
    print("Run again using 'python init_connectome_tract.py dataset subject'")
    sys.exit()

name = copier.subjectNameFromNumber(subject)
repititions = ['0' + `i` for i in range(1,10)] + ["10"]
rep_str = copier.arrToInterpolateString(repititions)
algs = [("tens", "dtidet", "lmax2"), ("detr", "csddet", "lmax8"), ("prob", "csdprob", "lmax8")]

mapping = {}
mapping["stn"] = {
    "input": "/N/dc2/projects/lifebid/HCP/Brent/cogs610/reps_data/stn_{}_{}_{}_rep{}.mat",
    "output": "O3D_STN/derivatives/connectome_tract/sub-{}_dwi_variant-{}life_trial-{}"
}

mapping["hcp3t"] = {
    "input": "/N/dc2/projects/lifebid/HCP/Brent/cogs610/reps_data/hcp_{}_{}_{}_rep{}.mat",
    "output": "O3D_HCP3T/derivatives/connectome_tract/sub-{}_dwi_variant-{}life_trial-{}"
}

mapping["hcp7t"] = {
    "input": "/N/dc2/projects/lifebid/HCP/Brent/cogs610/7t_reps_data/7t_{}_{}_{}_rep{}.mat",
    "output": "O3D_HCP7T/derivatives/connectome_tract/sub-{}_dwi_variant-{}life_trial-{}"
}

for a in algs:
    inalg, outalg, lmax = a
    in_str = mapping[dataset]["input"].format(name, inalg, lmax, rep_str)
    out_str = mapping[dataset]["output"].format(subject, outalg, rep_str)
    copier.copy(in_str, out_str, action = "mat2fiber")
