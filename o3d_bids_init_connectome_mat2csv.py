import scipy.io
import csv
import numpy
import sys

run_sanity_check = False

if len(sys.argv) > 1:
    if sys.argv[1] == "--help":
        print """
            Use --validate to convert and check results with matlab files
        """

    elif sys.argv[1] == "--validate":
        run_sanity_check = True

    else:
        mat = sys.argv[1]
        name = sys.argv[2]

def convert(input, name):
    # Load file
    mat = scipy.io.loadmat(input)

    # Get fiber count
    fiber_count = mat["emat"][:,:,0]

    # Get fiber density
    fiber_density = mat["emat"][:,:,1]

    # Write to csv
    new_fiber_count = name + '_variant-fcount_connectome.csv'
    new_fiber_density = name + '_variant-fdensity_connectome.csv'
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

    if run_sanity_check:
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

convert(mat, name)
