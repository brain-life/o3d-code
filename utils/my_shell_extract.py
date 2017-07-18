#!/usr/bin/env python

"""
Shell extraction

"""

import argparse
import re
import sys
import nibabel as nib
import numpy as np
from dipy.io import read_bvals_bvecs
from dipy.core.gradients import gradient_table


def shell_extraction(src_dwi, src_bvec, src_bval, 
                     out_dwi, out_bvec, out_bval, 
                     shell, delta=100, round=False, verbose=False):

    bvals, bvecs = read_bvals_bvecs(src_bval, src_bvec)

    img = nib.load(src_dwi)
    data = img.get_data()
    affine = img.get_affine()
    header = img.header

    sind = np.zeros((bvals.size), dtype=bool)
    bind = np.zeros((bvals.size), dtype=int)
    for b in shell:
        tind = (bvals < b+delta) & (bvals > b-delta)
        if round:
            bind = bind + tind * b
        sind = sind | tind          
    if round:
        bvals = bind

    shell_data = data[..., sind]
    shell_gtab = gradient_table(bvals[sind], 
                                bvecs[sind, :],
                                b0_threshold=10.0)

    shell_img = nib.Nifti1Image(shell_data, affine, header)
    shell_img.update_header()
    nib.save(shell_img, out_dwi)
    np.savetxt(out_bval, shell_gtab.bvals, fmt='%d', newline=' ')
    np.savetxt(out_bvec, shell_gtab.bvecs.T, fmt='%.6f')

    return sind.sum()



if __name__ == '__main__':
    
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', nargs='?', required=True,
                        help='The input dwi file')
    parser.add_argument('-ibvec', nargs='?', required=False,
                        help='The bvecs file, if omitted <dwifile>.bvec')
    parser.add_argument('-ibval', nargs='?', required=False,
                        help='The bvals file, if omitted <dwifile>.bval')
    parser.add_argument('-o', nargs='?', help='', required=True)
    parser.add_argument('-obvec', nargs='?', help='', required=False)
    parser.add_argument('-obval', nargs='?', help='', required=False)
    parser.add_argument('-b', type=int, nargs='+', help='', required=True)
    parser.add_argument('-r', action='store_true', 
                        required=False, default=False,
                        help='True if the b-value should be rounded')
    parser.add_argument('-delta', '-d', type=int, 
                        required=False, default=100,
                        help='The interval range of approximation for b-bvalue')
    parser.add_argument('-v', '-verbose', action='store_true', 
                        required=False, default=False)
   
    args = parser.parse_args()
    
    if not args.ibvec:
        args.ibvec = re.sub('\.nii(\.gz)?$','.bvecs',args.i)
    if not args.ibval:
        args.ibval = re.sub(r'\.nii(\.gz)?$','.bvals',args.i)
    if not args.obvec:
        args.obvec = re.sub(r'\.nii(\.gz)?$','.bvecs',args.o)
    if not args.obval:
        args.obval = re.sub(r'\.nii(\.gz)?$','.bvals',args.o)

    grad = shell_extraction(args.i, args.ibvec, args.ibval, 
                            args.o, args.obvec, args.obval, 
                            args.b, args.delta, args.r, args.v)

    print "Extracted %d gradients." % grad

    sys.exit()
