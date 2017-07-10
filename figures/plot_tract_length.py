#!/usr/bin/env python

import sys
import argparse
import numpy as np
import nibabel as nib
import matplotlib.pyplot as plt
from dipy.tracking.utils import length
from matplotlib import colors as mcolors


def plot_tract_length(sub, out):
    
    n_std = 3
    n_bin = 50
    
    col = {}
    col['dtidet'] = mcolors.cnames['green']
    col['csddet'] = mcolors.cnames['blue']
    col['csdprob'] = mcolors.cnames['red']    
    
    o3d = {}
    o3d['0001'] = 'STN'
    o3d['0002'] = 'STN'
    o3d['0003'] = 'STN'
    o3d['0004'] = 'STN'
    o3d['0005'] = 'HCP3T'
    o3d['0006'] = 'HCP3T'
    o3d['0007'] = 'HCP3T'
    o3d['0008'] = 'HCP3T'
    o3d['0009'] = 'HCP7T'
    o3d['0010'] = 'HCP7T'
    o3d['0011'] = 'HCP7T'
    o3d['0012'] = 'HCP7T'
    
    lab = {}
    lab['dtidet'] = 'dti deterministic'
    lab['csddet'] = 'csd deterministic'
    lab['csdprob'] = 'csd probabilistic'

    root = '/N/dc2/projects/o3d/data/derivatives/'
    src = root + 'tracking_{}_trk/sub-{}/sub-{}_dwi_var-{}life_run-{:02d}_tract.trk'
    
    s_max = 0
    
    for var in ['dtidet', 'csddet', 'csdprob']:
        
        # Load data
        s_length = []
        for r in range(10):
            f = src.format(var, sub, sub, var, r+1)
            str = nib.streamlines.load(f)
            l = [s for s in length(str.streamlines)]
            s_length.append(l)
            
        # Compute histogram
        l_all = np.hstack(s_length)
        l_min = l_all.min()
        l_max = l_all.max()
        l_bin = np.linspace(l_min, l_max, n_bin)
        a_hist = []
        a_bin = []
        for r in range(10):
            hist, bin_edges = np.histogram(s_length[r], bins=l_bin)
            a_hist.append(hist)
        a_hist = np.vstack(a_hist)
        mean_hist = []
        std_hist = []
        for b in range(n_bin-1):
            mean_hist.append(a_hist[:,b].mean())
            std_hist.append(a_hist[:,b].std())
        mean_hist = np.array(mean_hist)
        std_hist = np.array(std_hist)
        s_max = np.max([s_max, mean_hist.max()])
        
        # Plot the histogram
        palegreen = mcolors.cnames['palegreen']
        p = plt.subplot()
        p.spines['right'].set_visible(False)
        p.spines['top'].set_visible(False)
        p.spines['left'].set_position(('axes', -0.05))
        p.spines['bottom'].set_position(('axes', -0.05))
        p.yaxis.set_ticks_position('left')
        p.xaxis.set_ticks_position('bottom')
        p.set_xlim([0 - 0.5, 250 + 0.5]) 
        ymin = 0
        ymax = 20000 #s_max
        ymid = np.ceil(np.mean([ymin, ymax])).astype(np.int)
        p.set_ylim([ymin - 1, ymax])
        p.set_yticks([ymin, ymid, ymax])
        p.set_xticks(range(0,300,50))
        p.plot(l_bin[:-1], mean_hist, label=lab[var])
        p.fill_between(l_bin[:-1], mean_hist+(n_std*std_hist), \
                           mean_hist-(n_std*std_hist), color=palegreen, \
                           facecolor=palegreen, alpha=0.5, linewidth=1)

    plt.legend(loc='upper right', frameon=False)
    plt.title('Distribution of fibers length - Subject %s' % sub)
    plt.savefig(out, bbox_inches='tight', magnification=10)


if __name__ == '__main__':
    
    parser = argparse.ArgumentParser()
    parser.add_argument('sub', nargs='?',default='',
                        help='The subject ID')
    parser.add_argument('out', nargs='?',  default='default',
                        help='The output file where to save the plot')
                        
    args = parser.parse_args()

    plot_tract_length(args.sub, args.out)

    sys.exit()

