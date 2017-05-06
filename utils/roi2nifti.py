#!/usr/bin/env python

import os 
import sys
import argparse
import numpy as np
import nibabel as nib

roi_fs = [ \
    'lh_bankssts_label.nii.gz', \
    'lh_caudalanteriorcingulate_label.nii.gz', \
    'lh_caudalmiddlefrontal_label.nii.gz', \
    'lh_cuneus_label.nii.gz' \
    ]


def roi_merge(src, out):

    nii_all = ''
    for roi in range(len(roi_fs)):
        nii = os.path.join(src, roi_fs[roi])
        nii_img = nib.load(nii)
        nii_roi = nii_img.get_data() * (roi + 1)
        if nii_all == '':
            nii_all = nii_roi
        else:
            nii_all = nii_all + nii_roi

    nii_out = nib.Nifti1Image(nii_all.astype(np.uint8), nii_img.affine)
    nib.save(nii_out, out)


        
 
if __name__ == '__main__':
    
    parser = argparse.ArgumentParser()
    parser.add_argument( 'src', nargs='?', const=1, default='',
                        help='The source folder of roi nifti files')
    parser.add_argument('out', nargs='?',  const=1, default='',
                        help='The output of merge roi file')

    args = parser.parse_args()

    roi_merge(args.src, args.out)

    sys.exit()
  
