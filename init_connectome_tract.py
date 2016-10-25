import sys
import connectome_tract.connectome_tract_copy as copier

dataset = ""
subject = ""
if len(sys.argv) > 2:
    dataset = sys.argv[1]
    subject = sys.argv[2]
else:
    print("Script takes 2 arguments")
    print("Run again using 'python init_connectome_tract.py dataset subject'")
    sys.exit()

copier.copy(dataset, subject)
