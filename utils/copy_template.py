import o3d_bids_init_connectome_mat2csv
import sys
import re
import itertools

dummy = False
validate = False
touch = False
def getInterpolations(str):
    arr = re.findall("{(.*?)}", str)
    ret = []
    for stringlist in arr:
        ret.append(stringlist.split(","))
    return ret

def getReplacementString(str):
    return re.sub("{(.*?)}", "{}", str)

def getAllTuples(arr):
    return list(itertools.product(*arr))

def generateAllStrings(str):
    arr = getInterpolations(str)
    newstr = getReplacementString(str)
    tuples = getAllTuples(arr)
    ret = []
    for a in tuples:
        ret.append(newstr.format(*a))
    return ret

def arrToInterpolateString(arr):
    str = "{"
    for a in arr:
        str = str + a + ","
    str = str[:-1] + "}"
    return str

def subjectNameFromNumber(num):
    mapping = {
        "001": "FP",
        "002": "HT",
        "003": "KK",
        "004": "MP",
        "005": "105115",
        "006": "110411",
        "007": "111312",
        "008": "113619",
        "009": "108323",
        "010": "109123",
        "011": "131217",
        "012": "910241"
    }
    return mapping[num]

# in_inter takes an interpolatable file path for example:
# in_inter = "/path/to/{sub1,sub2,sub3,sub4}/sub/{file1,file2,file3}.mat"
def copy(in_inter, out_inter, action = "copy"):
    all_in = generateAllStrings(in_inter)
    all_out = generateAllStrings(out_inter)
    for i in range(len(all_in)):
        if (action == "mat2fiber"):
            o3d_bids_init_connectome_mat2csv.convert(all_in[i], all_out[i], dummy=True)
        elif (action == "mri_convert"):
            print "call(['module', 'load', 'freesurfer'])"
            print "mri_convert -it mgz -ot nii " + all_in[i] + " " + all_out[i]
        elif (action == "mrconvert"):
            print "call(['module', 'load', 'mrtrix'])"
            print "mrconvert " + all_in[i] + " " + all_out[i]
        elif (action == "copy"):
            print "cp " + all_in[i] + " >> " + all_out[i]

    # o3d_bids_init_connectome_mat2csv.convert(infile, outfile, dummy, validate, touch)

# in_str = "/N/dc2/projects/lifebid/HCP/Brent/cogs610/reps_data/stn_{FP,HT,KK,MP}_tens_lmax2_rep{01,02,03,04,05,06,07,08,09,10}.mat"
# out_str = "O3D/O3D_STN/derivatives/connectome_tract/dwi/sub-{001,002,003,004}_dwi_variant-dtidetlife_trial-{01,02,03,04,05,06,07,08,09,10}"
# copy(in_str, out_str, "mat2fiber")
