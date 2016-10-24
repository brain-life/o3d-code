import o3d_bids_init_connectome_mat2csv
import sys

dummy = False
validate = False
touch = False

mapping = {}
mapping["stn"] = {
    "subjects": ["001", "002", "003", "004"],
    "subjectNames": {
        "001": "FP",
        "002": "HT",
        "003": "KK",
        "004": "MP"
    },
    "repititions": ['0' + `i` for i in range(1, 10)] + ["10"],
    "algorithms": [("tens", "dtidet", "lmax2"), ("detr", "csddet", "lmax8"), ("prob", "csdprob", "lmax8")],
    "matlabFilepath": "/N/dc2/projects/lifebid/HCP/Brent/cogs610/reps_data/",
    "matlabSubpath": 'stn_',
    "destination": "O3D_STN"
}

mapping["hcp3t"] = {
    "subjects": ["005", "006", "007", "008"],
    "subjectNames": {
        "005": "105115",
        "006": "110411",
        "007": "111312",
        "008": "113619"
    },
    "repititions": ['0' + `i` for i in range(1, 10)] + ["10"],
    "algorithms": [("tens", "dtidet", "lmax2"), ("detr", "csddet", "lmax8"), ("prob", "csdprob", "lmax8")],
    "matlabFilepath": "/N/dc2/projects/lifebid/HCP/Brent/cogs610/reps_data/",
    "matlabSubpath": 'hcp_',
    "destination": "O3D_HCP3T"
}

mapping["hcp7t"] = {
    "subjects": ["009", "010", "011", "012"],
    "subjectNames": {
        "009": "108323",
        "010": "109123",
        "011": "131217",
        "012": "910241"
    },
    "repititions": ['0' + `i` for i in range(1, 10)] + ["10"],
    "algorithms": [("tens", "dtidet", "lmax2"), ("detr", "csddet", "lmax8"), ("prob", "csdprob", "lmax8")],
    "matlabFilepath": "/N/dc2/projects/lifebid/HCP/Brent/cogs610/7t_reps_data/",
    "matlabSubpath": '7T_',
    "destination": "O3D_HCP3T"
}

def copy(dataset, subject):
    destination = mapping[dataset]["destination"] + "/derivatives/connectome_tract/sub-" + subject + "/dwi/"
    for rep in mapping[dataset]["repititions"]:
        for alg in mapping[dataset]["algorithms"]:
            inalg, outalg, lmax = alg
            infile = mapping[dataset]["matlabFilepath"] + mapping[dataset]["matlabSubpath"] + mapping[dataset]["subjectNames"][subject] + '_' + inalg +'_' + lmax + '_rep' + rep + '.mat'
            outfile = destination + 'sub-' + subject + '_dwi_variant-' + outalg + 'life_trial-' + rep
            o3d_bids_init_connectome_mat2csv.convert(infile, outfile, dummy, validate, touch)


if len(sys.argv) > 2 and __name__ == '__main__':
    if sys.argv[1] == "--dummy":
        dummy = True
    if sys.argv[1] == "--validate":
        validate = True
    if sys.argv[1] == "--touch":
        touch = True

    dataset = sys.argv[2]
    subject = sys.argv[3]
    copy(dataset, subject)
