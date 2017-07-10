#!/usr/bin/env python

import re
import sys
import glob
import argparse
import numpy as np
import nibabel as nib
import vtk.util.colors as colors
import dipy.io.vtk as io_vtk
import dipy.viz.utils as ut_vtk
from dipy.viz import window, actor
from dipy.viz.colormap import line_colors
from dipy.tracking.streamline import transform_streamlines
from nibabel import trackvis as tv

from dipy.utils.optpkg import optional_package
vtk, have_vtk, setup_module = optional_package('vtk')


def load_surf_data(surf_src):

    img = nib.load(surf_src[0])
    d_vertices, d_triangles = img.darrays
    vertices = d_vertices.data
    triangles = d_triangles.data

    #img = nib.load(surf_src[1])
    #d_vertices, d_triangles = img.darrays
    #vertices = np.hstack(vertices, d_vertices.data)
    #triangles = np.hastack(triangles, d_triangles.data + d_vertices.shape[0])

    my_polydata = vtk.vtkPolyData()
    ut_vtk.set_polydata_vertices(my_polydata, vertices)
    ut_vtk.set_polydata_triangles(my_polydata, triangles)

    return my_polydata


def plot_figure_tract_lap(trk_all_src, 
                          bundle='default', surf_src=False, figure=False):

    # tomato aquamarine violet green lavender navy sea_green saddle_brown
    color = {}
    color['ARCl'] = colors.salmon
    color['ATRl'] = colors.sea_green_dark
    color['CCgl'] = colors.gold
    color['CHyl'] = colors.cornflower
    color['CSTl'] = colors.royal_blue
    color['IFOFl'] = colors.sea_green
    color['ILFl'] = colors.firebrick
    color['SLFl'] = colors.purple_medium
    color['UFl'] = colors.plum
    color['FMI'] = colors.rosy_brown
    color['FMJ'] = colors.khaki_dark
    color[''] = colors.gold
    color[''] = colors.gold
    color[''] = colors.gold
    color[''] = colors.gold
    color[''] = colors.gold
    color[''] = colors.gold
    color[''] = colors.gold
    color[''] = colors.gold
    color[''] = colors.gold
    
    camera = {}
    camera['default', 'position'] = (-176.42, 118.52, 128.20)
    camera['default', 'focal_point'] = (113.30, 128.31, 76.56)
    camera['default', 'view_up'] = (0.18, 0.00, 0.98)
    camera['STN', 'position'] = (-265.19, -68.80, -137.34)
    camera['STN', 'focal_point'] = (41.91, -6.24, 32.09)
    camera['STN', 'view_up'] = (-0.50, 0.10, 0.86)
    camera['HCP3T', 'position'] = (-229.37, -170.37, 237.24)
    camera['HCP3T', 'focal_point'] = (-5.89, -17.01, 6.00)
    camera['HCP3T', 'view_up'] = (0.40, 0.54, 0.74)
    camera['HCP7T', 'position'] = (-109.49, -18.45, 46.25)
    camera['HCP7T', 'focal_point'] = (-37.86, 8.29, -8.12)
    camera['HCP7T', 'view_up'] = (0.38, 0.52, 0.76)
 
    ren = window.Renderer()
    ren.background((1., 1., 1.))

    for trk_src in trk_all_src:

        tag = re.search('set-(.+?)_tract', trk_src).group(1)
        tractogram = nib.streamlines.load(trk_src)
        fibers = tractogram.streamlines
        print tag

        if fibers.total_nb_rows != 0:
            stream_actor = actor.streamtube(fibers, colors=color[tag],
                                            linewidth=0.5, tube_sides=100)
        #props = stream_actor.GetProperty()
        #props.SetDiffuse(0.5)
        #props.SetSpecularPower(100.0)
        #props.LightingOn()
            ren.add(stream_actor)
    
    if surf_src:
        surf_data = load_surf_data(surf_src)
        surf_actor = ut_vtk.get_actor_from_polydata(surf_data)
        surf_actor.GetProperty().SetOpacity(0.1)
        ren.add(surf_actor)

    ren.set_camera(position=camera[bundle,'position'],
                   focal_point=camera[bundle, 'focal_point'],
                   view_up=camera[bundle, 'view_up'])
    # ren.azimuth(180)
    
    if figure:
        window.record(ren, out_path=figure, magnification=5, size=(600, 600))
    else:
        window.show(ren, size=(600, 600), reset_camera=False,
                    order_transparent=True)
        camera = ren.camera()
        print 'Camera Settings'
        print 'Position: ', '(%.2f, %.2f, %.2f)' % camera.GetPosition()
        print 'Focal Point: ', '(%.2f, %.2f, %.2f)' % camera.GetFocalPoint()
        print 'View Up: ', '(%.2f, %.2f, %.2f)' % camera.GetViewUp()
 


if __name__ == '__main__':
    
    parser = argparse.ArgumentParser()
    parser.add_argument( 'sub', nargs='?',default='',
                        help='The source trk files')
    parser.add_argument('-png', nargs='?', const=1, default='',
                        help='The output png file')
    parser.add_argument('-camera', nargs='?',  const=1, default='default',
                        help='The type of tract')
    parser.add_argument('-run', nargs='?',  const=1, default='01',
                        help='The type of tract')
    parser.add_argument('-var', nargs='?',  const=1, default='dtidet',
                        help='The type of tract')
    parser.add_argument('-surf', nargs='+',  default='',
                        help='The surface gifti files')
                        
    args = parser.parse_args()

    src = '/N/dc2/projects/o3d/data/derivatives/dissection_afq_{}_trk/sub-{}/'
    src = src.format(args.var, args.sub)
    trk = 'sub-{}_dwi_var-{}life_run-{}_var-afq_set-*l_tract.trk'
    trk = trk.format(args.sub, args.var, args.run)
    afq = glob.glob(src + trk)

    plot_figure_tract_lap(afq, args.camera, args.surf, args.png)

    sys.exit()

