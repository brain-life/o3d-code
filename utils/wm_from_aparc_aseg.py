#!/usr/bin/env python

import sys
import argparse
import numpy as np
import nibabel as nib

def wm_from_aparc_aseg(aparc_aseg_src, wm_mask_out):

    roi = [2, 41, 16, 17, 28, 60, 51, 53, 12, 52, 13, 18, 54, 50, 11, 251, 252, 253, 254, 255, 10, 49, 46, 7]

    img = nib.load(aparc_aseg_src)
    seg = img.get_data()
    wm = np.zeros_like(seg)
    aff = img.affine

    for r in roi:
        wm[seg == r] = 1

    nib.save(nib.Nifti1Image(wm, aff), wm_mask_out)



if __name__ == '__main__':
    
    parser = argparse.ArgumentParser()
    parser.add_argument( 'aparc_aseg', nargs='?',default='',
                        help='The source aparc+aseg file')
    parser.add_argument('wm_mask', nargs='?', default='',
                        help='The output white matter mask file')
                        
    args = parser.parse_args()

    wm_from_aparc_aseg(args.aparc_aseg, args.wm_mask)

    sys.exit()

