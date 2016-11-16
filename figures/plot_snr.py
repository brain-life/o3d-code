#!/usr/bin/env python

import os
import sys
import h5py
import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
from scipy.stats import norm

# STN   (107, 141, 101) 1523787
# HCP3T (129, 169, 121) 2637921
# HCP7T (173, 207, 173) 6195303

vox_num = {}
vox_num['STN'] = 1523787
vox_num['HCP3T'] = 2637921
vox_num['HCP7T'] = 6195303

label = {}
label['STN', 0] = 'sub-001'
label['STN', 1] = 'sub-002'
label['STN', 2] = 'sub-003'
label['STN', 3] = 'sub-004'
label['HCP3', 0] = 'sub-005'
label['HCP3', 1] = 'sub-006'
label['HCP3', 2] = 'sub-007'
label['HCP3', 3] = 'sub-008'
label['HCP7', 0] = 'sub-009'
label['HCP7', 1] = 'sub-010'
label['HCP7', 2] = 'sub-011'
label['HCP7', 3] = 'sub-012'

color = {}
color['STN'] = 'r--'
color['HCP3'] = 'b--'
color['HCP7'] = 'g--'

line_style = ['-', '--', '-.', ':']


def load_snr(snr_src):

    snr_all = []
    snr_hdf5 = h5py.File(snr_src,'r')
    snr_lab = snr_hdf5.keys()[1]
    snr_data = snr_hdf5[snr_lab].value
    for i in np.arange(4):
        snr_sub = snr_data[i][0]
        snr_arr = snr_hdf5[snr_sub]['snr'].value
        snr_arr = snr_arr[~np.isnan(snr_arr)]
        snr_arr = snr_arr[snr_arr < np.inf]
        snr_all.append(snr_arr)
    return snr_all


def plot_snr(snr, bin, label, line, color, factor=1):

    hist, bin_edges = np.histogram(snr, bins = bin)
    (mu, sigma) = norm.fit(snr)
    fit = mlab.normpdf(bin_edges, mu, sigma)
    l = plt.plot(bin_edges, fit / factor, color, 
                 linestyle=line, linewidth=0.7, label=label)


def plot_one_snr(snr_file, snr_out):

    snr = load_snr(snr_file)

    snr_all = np.hstack(snr)
    snr_min = snr_all.min()
    snr_max = snr_all.max()
    snr_bin = np.linspace(snr_min, snr_max, 500)

    if 'STN' in snr_file:
        tag = 'STN'
    if 'HCP3' in snr_file:
        tag = 'HCP3'
    if 'HCP7' in snr_file:
        tag = 'HCP7'

    plot_snr(snr[0], snr_bin, label[tag, 0], line_style[0], color[tag])
    plot_snr(snr[1], snr_bin, label[tag, 1], line_style[1], color[tag])
    plot_snr(snr[2], snr_bin, label[tag, 2], line_style[2], color[tag])
    plot_snr(snr[3], snr_bin, label[tag, 3], line_style[3], color[tag])

    plt.xlim([0, 150])
    plt.ylim([0, 0.07])
    plt.xlabel('snr')
    plt.ylabel('')
    plt.legend(loc='upper right')
    plt.title(tag)

    if snr_out:
        plt.savefig(snr_out, bbox_inches='tight', magnification=10)
    else:
        plt.show()


def plot_all_snr(snr_file1, snr_file2, snr_file3, snr_out):

    snr1 = load_snr(snr_file1)
    snr2 = load_snr(snr_file2)
    snr3 = load_snr(snr_file3)

    snr_all = np.hstack((np.hstack(snr1), 
                         np.hstack(snr2),
                         np.hstack(snr3)))

    snr_min = snr_all.min()
    snr_max = snr_all.max()
    snr_bin = np.linspace(snr_min, snr_max, 1000)

    snr1 = np.hstack(snr1)
    snr2 = np.hstack(snr2)
    snr3 = np.hstack(snr3)

    plot_snr(snr1, snr_bin, 'STN',  line_style[0], 'r--')
    plot_snr(snr2, snr_bin, 'HCP3', line_style[0], 'b--')
    plot_snr(snr3, snr_bin, 'HCP7', line_style[0], 'g--')

    plt.xlim([0, 150])
    plt.ylim([0, 0.07])
    plt.xlabel('snr')
    plt.ylabel('')
    plt.legend(loc='upper right')
    plt.title('Distribution of snr')

    if snr_out:
        plt.savefig(snr_out, bbox_inches='tight', magnification=10)
    else:
        plt.show()


if __name__ == '__main__':
    
    save_plot = False
    if (len(sys.argv) == 3) or (len(sys.argv) == 5):
        save_plot = sys.argv[-1]

    if len(sys.argv) < 4:
        plot_one_snr(sys.argv[1], save_plot)

    if len(sys.argv) > 3:
        plot_all_snr(sys.argv[1], sys.argv[2], sys.argv[3], save_plot)

    sys.exit()
