import o3d_bids_init_connectome_mat2csv
from subprocess import call
import sys
import re
import itertools
import tractconverter
from tractconverter import FORMATS

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

def parseCommandLine(argv):
    dataset = ""
    subject = ""
    root = "./"
    if len(argv) > 2:
        dataset = argv[1]
        subject = argv[2]
        if len(argv) > 3:
            root = argv[3] + "/"
    else:
        print("Script takes 2 arguments")
        print("Run again using 'python init_connectome_tract.py dataset subject'")
        sys.exit()
    return (dataset, subject, root)

def mri_convert(infile, outfile, dummy = True):
    if dummy:
        print "call(['module', 'load', 'freesurfer'])"
        print "mri_convert -it mgz -ot nii " + infile + " " + outfile
    else:
        # call(['module', 'load', 'freesurfer'])
        call(['mri_convert', '-it', 'mgz', '-ot', 'nii', infile, outfile])

def mrconvert(infile, outfile, dummy = True):
    if dummy:
        print "call(['module', 'load', 'mrtrix'])"
        print "mrconvert " + infile + " " + outfile
    else:
        # call(['module', 'load', 'mrtrix'])
        call(['mrconvert', infile, outfile])

def mask(infile, outfile, mask, dummy = True):
    if dummy:
        print ""
    else:
        call(["fslmaths", infile, "-mas", mask, outfile])

def life(infile, outfile, anatomy, dummy = True):
    if dummy:
        print 'matlab -nosplash -nodesktop -r "addpath(genpath(\'/N/dc2/projects/lifebid/Paolo/local/matlab\'));fe2trk ' + infile + ' ' + anatomy + ' ' + outfile + '"'
    else:
        call(['matlab', '-nosplash', '-nodesktop', '-r', 'addpath(genpath(\'/N/dc2/projects/lifebid/Paolo/local/matlab\'));fe2trk ' + infile + ' ' + anatomy + ' ' + outfile + ';exit;'])
# matlab -nosplash -nodesktop -r "addpath(genpath('/N/dc2/projects/lifebid/Paolo/local/matlab'));fe2trk /N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-FP/fe_structures/fe_structure_FP_96dirs_b2000_1p5iso_STC_run01_tensor__connNUM01.mat /N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/paper_datasets/STN/sub-FP/dwi/run01_fliprot_aligned_trilin.nii.gz out.trk"
# export MATLABPATH="/N/u/andnpatt/Karst/lifebid/o3d-code/utils"

def afq2trk(infile, outfile, anatomy, dummy = True):
    if dummy:
        print 'matlab -nosplash -nodesktop -r "addpath(genpath(\'/N/dc2/projects/lifebid/Paolo/local/matlab\'));afq2trk ' + infile + ' ' + anatomy + ' ' + outfile + '"'
    else:
        call(['matlab', '-nosplash', '-nodesktop', '-r', 'addpath(genpath(\'/N/dc2/projects/lifebid/Paolo/local/matlab\'));afq2trk ' + infile + ' ' + anatomy + ' ' + outfile + ';exit;'])

def trk2tck(infile, outfile, anatomy, dummy = True):
    if dummy:
        print ''
    else:
        trk_format = FORMATS['trk']
        tck_format = FORMATS['tck']

        input = trk_format(infile, anatomy)
        output = tck_format.create(outfile, input.hdr, anatomy)
        tractconverter.convert(input, output)

def tck2trk(infile, outfile, anatomy, dummy = True):
    if dummy:
        print ''
    else:
        trk_format = FORMATS['trk']
        tck_format = FORMATS['tck']

        input = tck_format(infile, anatomy)
        output = trk_format.create(outfile, input.hdr, anatomy)
        tractconverter.convert(input, output)

# in_inter takes an interpolatable file path for example:
# in_inter = "/path/to/{sub1,sub2,sub3,sub4}/sub/{file1,file2,file3}.mat"
def copy(in_inter, out_inter, action = "copy", dummy = True, anatomy = ""):
    all_in = generateAllStrings(in_inter)
    all_out = generateAllStrings(out_inter)
    for i in range(len(all_in)):
        if (action == "mat2fiber"):
            o3d_bids_init_connectome_mat2csv.convert(all_in[i], all_out[i], dummy=dummy)
        elif (action == "mri_convert"):
            mri_convert(all_in[i], all_out[i], dummy)
        elif (action == "mrconvert"):
            mrconvert(all_in[i], all_out[i], dummy)
        elif (action == "LIFE"):
            life(all_in[i], all_out[i], dummy = dummy, anatomy = anatomy)
        elif (action == "afq2trk"):
            afq2trk(all_in[i], all_out[i], dummy = dummy, anatomy = anatomy)
        elif (action == "trk2tck"):
            trk2tck(all_in[i], all_out[i], dummy = dummy, anatomy = anatomy)
        elif (action == "tck2trk"):
            tck2trk(all_in[i], all_out[i], dummy = dummy, anatomy = anatomy)
        elif (action == "mask"):
            mask(all_in[i], all_out[i], dummy = dummy, mask = anatomy)
        elif (action == "copy"):
            if dummy:
                print "cp " + all_in[i] + " >> " + all_out[i]
            else:
                call(['cp', all_in[i], all_out[i]])


    # o3d_bids_init_connectome_mat2csv.convert(infile, outfile, dummy, validate, touch)

# in_str = "/N/dc2/projects/lifebid/HCP/Brent/cogs610/reps_data/stn_{FP,HT,KK,MP}_tens_lmax2_rep{01,02,03,04,05,06,07,08,09,10}.mat"
# out_str = "O3D/O3D_STN/derivatives/connectome_tract/dwi/sub-{001,002,003,004}_dwi_variant-dtidetlife_trial-{01,02,03,04,05,06,07,08,09,10}"
# copy(in_str, out_str, "mat2fiber")
