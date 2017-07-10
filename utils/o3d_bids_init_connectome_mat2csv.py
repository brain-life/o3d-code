import scipy.io
import h5py
import csv
import numpy
import sys
from subprocess import call


def convert(input, name, dummy = False, validate = False, touch = False):
    new_fiber_count = name + '_var-fcount_connectome.csv'
    new_fiber_density = name + '_var-fdensity_connectome.csv'

    if not dummy and not touch:
        # Load file
        # mat = scipy.io.loadmat(input)
        mat = h5py.File(input, 'r')
        kmat = mat.keys()[5]
        omat = mat[kmat].value

        # Get fiber count
        #fiber_count = mat["omat"][0,0,1]
        fiber_count = omat[0,:,:]

        # Get fiber density
        #fiber_density = mat["omat"][0,0,2]
        fiber_density = omat[1,:,:]

        f = open(new_fiber_count, 'w')
        writer = csv.writer(f)
        for i in range(64):
            writer.writerow(fiber_count[i])
        f.close()

        f = open(new_fiber_density, 'w')
        writer = csv.writer(f)
        for i in range(64):
            writer.writerow(fiber_density[i])
        f.close()
    else:
        print input + " >> " + new_fiber_count
        print input + " >> " + new_fiber_density
        if touch:
            call(["touch", new_fiber_count])
            call(["touch", new_fiber_density])

    if validate:
        ###### SANITY CHECK ######
        # Compare to Matlab Generated csv's
        new_fc_dat = numpy.loadtxt(open(new_fiber_count, 'rb'), delimiter=',')
        for i in range(64):
            for j in range(64):
                if fiber_count[i][j] != new_fc_dat[i][j]:
                    raise Exception('Fiber count values mismatched at location: ' + `i, j`)
                    new_fd_dat = numpy.loadtxt(open(new_fiber_density, 'rb'), delimiter=',')
                    for i in range(64):
                        for j in range(64):
                            if fiber_density[i][j] != new_fd_dat[i][j]:
                                raise Exception('Fiber density values mismatched at location: ' + `i, j`)

                                print name + " passed validation"

if len(sys.argv) > 1 and __name__ == '__main__':
    if sys.argv[1] == "--help":
        print """
            Use --validate to convert and check results with matlab files
        """

    elif sys.argv[1] == "--validate":
        mat = sys.argv[2]
        name = sys.argv[3]
        convert(mat, name, validate = True)

    else:
        mat = sys.argv[1]
        name = sys.argv[2]
        convert(mat, name)
