function initConnectome(fe_src, lab_src, csv1, csv2)
%initConnectome returns the count and density networks 
%   I return the standard matrices and output files for O3D
%
% INPUTS:
%     fe_src   - a loaded fe structure to generate a network for   
%     lab_src  - a loaded .nii in ACPC space with labels corresponding to network nodes
%     csv1     - the output file for count networks
%     csv2     - the output file for density networks
%
% OUTPUT:
%     omat  - all the count networks generated
%     olab  - the labels corresponding to omat networks; labels for the 3rd axis of omat
%

% load fe structure to generate a network

fe=load(fe_src);

% load .nii in ACPC space with labels corresponding to network nodes
labels=niftiRead(lab_src);

% the number of cores to open in parallel pool
nclust=5;

% the directory specify where parpool tmp files are written
cacheDir='/tmp';

fnCreateCountNetworks(fe.fe, labels, nclust, cacheDir, csv1, csv2);

end
