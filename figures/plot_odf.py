#!/usr/bin/env python

import re
import sys
import argparse
import numpy as np
import nibabel as nib
from dipy.viz import fvtk
from dipy.data import get_sphere
from dipy.segment.mask import applymask
from dipy.reconst.shm import sh_to_sf

#from dipy.utils.optpkg import optional_package
#vtk, have_vtk, setup_module = optional_package('vtk')


def plot_odf_slice(odf_src, mask_src=False, slice=False, figure=False):

    img_odf = nib.load(odf_src)
    data_odf = img_odf.get_data()
    print odf_src
    print data_odf.shape

    if mask_src:
        mask_img = nib.load(mask_src)
        mask_data = mask_img.get_data()
        data_odf = applymask(data_odf, mask_data)

    if slice:
        slice_odf = data_odf(slice)
        print 'ALL'
    else:
        if 'sub-005' in odf_src:
            slice_odf = data_odf[40:65, 118:140, 54:55,:]
        if 'sub-006' in odf_src:
            slice_odf = data_odf[64:114, 110:160, 54:55,:]
        if 'sub-007' in odf_src:
            slice_odf = data_odf[64:114, 110:160, 54:55,:]
        if 'sub-008' in odf_src:
            slice_odf = data_odf[64:114, 110:160, 54:55,:]
        if 'sub-009' in odf_src:
            slice_odf = data_odf[85:145, 130:195, 77:78, :]
        if 'sub-010' in odf_src:
            slice_odf = data_odf[85:145, 130:195, 77:78, :]
        if 'sub-011' in odf_src:
            slice_odf = data_odf[85:145, 130:195, 77:78, :]
        if 'sub-012' in odf_src:
            slice_odf = data_odf[85:145, 130:195, 77:78, :]

    print slice_odf.shape
    sh_order = 8
    sphere = get_sphere('symmetric724')
    data_sf = sh_to_sf(slice_odf, sphere, sh_order, basis_type='mrtrix')

    scale_odf = 1.0
    size_odf = (600, 600)

    ren = fvtk.ren()
    odf_actor = fvtk.sphere_funcs(data_sf, sphere, scale=scale_odf, norm=False)
    fvtk.add(ren, odf_actor)

    ren.set_camera(
        position=(-1.38, -1.05, 93.67),
        focal_point=(-1.38, -1.05, -0.50),
        view_up=(0.00, 1.00, 0.00))

    if figure:
        fvtk.record(ren, out_path=figure, magnification=10, size=size_odf)
    else:
        fvtk.show(ren, size=size_odf, reset_camera=True)
        camera = ren.camera()
        print 'Camera Settings'
        print 'Position: ', '(%.2f, %.2f, %.2f)' % camera.GetPosition()
        print 'Focal Point: ', '(%.2f, %.2f, %.2f)' % camera.GetFocalPoint()
        print 'View Up: ', '(%.2f, %.2f, %.2f)' % camera.GetViewUp()




if __name__ == '__main__':
    
    parser = argparse.ArgumentParser()
    parser.add_argument( 'odf', nargs='?', const=1, default='',
                        help='The source odf file')
    parser.add_argument('-mask', nargs='?',  const=1, default=False,
                        help='The mask file')
    parser.add_argument('-slice', '-s', nargs='?',  const=1, default=False,
                        help='The slice of odf')
    parser.add_argument('-png', nargs='?', const=1, default=False,
                        help='The output png file')                        
    args = parser.parse_args()

    plot_odf_slice(args.odf, args.mask, args.slice, args.png)

    sys.exit()

