#!/usr/bin/env python

import sys
import argparse
import matplotlib.pyplot as plt
import numpy as np
import nibabel as nib
from matplotlib import colors as mcolors


def load_afq_stat(sub, trk):
    ref = '/N/dc2/projects/o3d/data/derivatives/dissection_afq_{}_trk/sub-{}/sub-{}_dwi_var-{}life_run-{}_var-afq_set-{}_tract.trk'
    run = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10']
    afq = ['ARCl', 'ARCr', 'ATRl', 'ATRr', 'CCgl', 'CCgr', 'CHyl', 'CHyr', 'CSTl', 'CSTr', 'FMI', 'FMJ', 'IFOFl', 'IFOFr', 'ILFl', 'ILFr', 'SLFl', 'SLFr', 'UFl', 'UFr']
    o3d = {'0001':'STN', '0002':'STN', '0003':'STN', '0004':'STN', \
           '0005':'HCP3T', '0006':'HCP3T', '0007':'HCP3T', '0008':'HCP3T', \
           '0009':'HCP7T', '0010':'HCP7T', '0011':'HCP7T', '0012':'HCP7T'}
    stat = np.empty((len(afq), len(run)))
    for f in range(len(afq)):
        for r in range(len(run)):
            src = ref.format(trk, sub, sub, trk, run[r], afq[f])
            tractogram = nib.streamlines.load(src)
            stat[f, r] = tractogram.header['nb_streamlines']
    return stat


def plot_afq_stat(sub, eps=False):

    col = {}
    col['dtidet'] = mcolors.cnames['green']
    col['csddet'] = mcolors.cnames['blue']
    col['csdprob'] = mcolors.cnames['red']    
     
    variant = ['dtidet', 'csddet', 'csdprob']
    label = ['ARCl', 'ARCr', 'ATRl', 'ATRr', 'CCgl', 'CCgr', 'CHyl', 'CHyr', 'CSTl', 'CSTr', 'FMI', 'FMJ', 'IFOFl', 'IFOFr', 'ILFl', 'ILFr', 'SLFl', 'SLFr', 'UFl', 'UFr']
    legenda = ['dti det.', 'csd det.', 'csd prob.']
    stat1 = load_afq_stat(sub, variant[0])
    stat2 = load_afq_stat(sub, variant[1])
    stat3 = load_afq_stat(sub, variant[2])
    p = plt.subplot()
    ind = np.arange(len(label)) + 1
    p.set_yticks(ind)
    xmax = np.vstack([stat1, stat2, stat3]).max()
    xmin = np.vstack([stat1, stat2, stat3]).min()
    p.spines['right'].set_visible(False)
    p.spines['top'].set_visible(False)
    p.spines['left'].set_position(('axes', -0.05))
    p.spines['bottom'].set_position(('axes', -0.05))
    p.yaxis.set_ticks_position('left')
    p.xaxis.set_ticks_position('bottom')
    p.set_ylim([1 - 0.5, len(label) + 0.5])
    #p.set_ylim([ymin - 1, ymax])
    p.set_xlim([-10, 2000])
    p.set_yticklabels(label)
    #p.set_yticks([ymin, np.mean([ymin, ymax]), ymax])
    p.set_xticks([0, 1000, 2000])
    p.errorbar(stat1.mean(axis=1), ind - 0.2, xerr=stat1.std(axis=1), \
                   label=legenda[0], linestyle='None', \
                   marker='D', color=col['dtidet'])
    p.errorbar(stat2.mean(axis=1), ind, xerr=stat2.std(axis=1), \
                   label=legenda[1], linestyle='None', \
                   marker='s', color=col['csddet'])
    p.errorbar(stat3.mean(axis=1), ind + 0.2, xerr=stat3.std(axis=1), \
                   label=legenda[2], linestyle='None', \
                   marker='o', color=col['csdprob'])
    handles, labels = p.get_legend_handles_labels()
    handles = [h[0] for h in handles]
    plt.legend(handles, labels, loc='upper center', frameon=False, \
                   numpoints=1, ncol=3, bbox_to_anchor=(0.5, -0.1))
    plt.title('AFQ Fibers Number - Subject: ' + sub)
    if eps:
        plt.savefig(eps, bbox_inches='tight', magnification=10)
    else:
        plt.show()
        
    plt.clf()



if __name__ == '__main__':
    
    parser = argparse.ArgumentParser()
    parser.add_argument('sub', nargs='?',default='',
                        help='The subject ID')
    parser.add_argument('out', nargs='?',  default='default',
                        help='The output file where to save the plot')
                        
    args = parser.parse_args()

    plot_afq_stat(args.sub, args.out)

    sys.exit()

