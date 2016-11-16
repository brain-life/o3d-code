#!/usr/bin/env python

import sys
import numpy as np
from dipy.viz import fvtk
from dipy.data import get_sphere
from dipy.reconst.csdeconv import AxSymShResponse


def plot_response(src_txt, out_png=False):

    response_src = np.loadtxt(src_txt)
    sphere = get_sphere('symmetric724')
    sh_resp = AxSymShResponse(0, response_src)
    sig_resp = sh_resp.on_sphere(sphere)

    ren = fvtk.ren()
    response_actor = fvtk.sphere_funcs(sig_resp, sphere)
    fvtk.add(ren, response_actor)
    my_camera = ren.camera()
    my_camera.SetPosition(-0.19, -6.03, 1.27)
    my_camera.SetFocalPoint(-1.10, -1.10, -1.10)
    my_camera.SetViewUp(0.24, 0.46, 0.86)

    if out_png:
        fvtk.record(ren, out_path=out_png, magnification=10, size=(600, 600))
    else:
        fvtk.show(ren, reset_camera=False)
        print 'Camera Settings'
        print 'Position: ', '(%.2f, %.2f, %.2f)' % my_camera.GetPosition()
        print 'Focal Point: ', '(%.2f, %.2f, %.2f)' % my_camera.GetFocalPoint()
        print 'View Up: ', '(%.2f, %.2f, %.2f)' % my_camera.GetViewUp()


if __name__ == '__main__':
    
    save_plot = False
    if len(sys.argv) == 3:
        save_plot = sys.argv[-1]

    plot_response(sys.argv[1], save_plot)

    sys.exit()
