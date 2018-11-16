#!/usr/bin/env python

"""
Extraction and average of b0 from dwi file

"""

import argparse
import re
import sys
import nibabel as nib
import numpy as np
from dipy.io import read_bvals_bvecs
from dipy.core.gradients import gradient_table


def shell_extraction(src_dwi, src_bvec, src_bval, out_b0,
                     delta=100, verbose=False):

    shell = [0]
    
    bvals, bvecs = read_bvals_bvecs(src_bval, src_bvec)

    img = nib.load(src_dwi)
    data = img.get_data()
    affine = img.get_affine()
    header = img.header

    sind = np.zeros((bvals.size), dtype=bool)
    for b in shell:
        tind = (bvals < b+delta) & (bvals > b-delta)
        sind = sind | tind          

    shell_data = data[..., sind].mean(axis=3)
    
    shell_img = nib.Nifti1Image(shell_data, affine, header)
    shell_img.update_header()
    nib.save(shell_img, out_b0)
    
    return sind.sum()



if __name__ == '__main__':
    
    parser = argparse.ArgumentParser()
    parser.add_argument('dwi', nargs='?',
                        help='The input dwi file')
    parser.add_argument('b0', nargs='?',
                        help='The output b0 file')
    parser.add_argument('-bvec',
                        help='The input bvec file')
    parser.add_argument('-bval',
                        help='The input bval file')
    parser.add_argument('-delta', '-d', type=int, 
                        required=False, default=100,
                        help='The interval range of approximation for b-bvalue')
    parser.add_argument('-v', '-verbose', action='store_true', 
                        required=False, default=False)
   
    args = parser.parse_args()
    
    if not args.bvec:
        args.bvec = re.sub('\.nii(\.gz)?$','.bvecs',args.dwi)
    if not args.bval:
        args.bval = re.sub(r'\.nii(\.gz)?$','.bvals',args.dwi)
    
    grad = shell_extraction(args.dwi, args.bvec, args.bval, args.b0,
                            args.delta, args.v)

    print "Extracted %d gradients." % grad

    sys.exit()
