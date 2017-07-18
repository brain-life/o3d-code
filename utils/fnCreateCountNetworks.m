function [ omat, olab ] = fnCreateCountNetworks(fe, labels, nclust, cacheDir, csv1, csv2)
%fnCreateCountNetworks returns the count and density networks 
%   I return the standard matrices and output files for O3D
%
% INPUTS:
%     fe       - a loaded fe structure to generate a network for   
%     labels   - a loaded .nii in ACPC space with labels corresponding to network nodes
%     nclust   - the number of cores to open in parallel pool
%     cacheDir - the directory specify where parpool tmp files are written
%     csv1     - the output file for count networks
%     csv2     - the output file for density networks
%
% OUTPUT:
%     omat  - all the count networks generated
%     olab  - the labels corresponding to omat networks; labels for the 3rd axis of omat
%
% Brent McPherson, (c) 2017; Indiana University
%

display('Extracting data for network construction...');

% extract all needed out of FE
fg               = feGet(fe,   'fg acpc'); 
fascicle_length  = fefgGet(fg, 'length');
fascicle_weights = feGet(fe,   'fiber weights');

% manage workspace
clear fe

%% start parallel pool

disp(['Opening parallel pool with ', num2str(nclust), ' cores...']);

% create parallel cluster object
c = parcluster;

% set number of cores from arguments
c.NumWorkers = nclust;

% set temporary cache directory
t = tempname(cacheDir);

% make cache dir
OK = mkdir(t);

% check and set cachedir location
if OK
    % set local storage for parpool
    c.JobStorageLocation = t;
end

% start parpool - close parpool at end of fxn
pool = parpool(c, nclust, 'IdleTimeout', 120);

%% create networks

disp('Computing network values...');

% assign streamline endpoints to labeled volume
[ pconn, ~ ] = feCreatePairedConnections(labels, fg.fibers, fascicle_length, fascicle_weights);

%% create adjacency matrices

disp('Creating network statistics...');

% create all streamline matrices
[ amat, alab ] = feCreateAdjacencyMatrices(pconn, 'all');
[ nmat, nlab ] = feCreateAdjacencyMatrices(pconn, 'nzw');

% combine outputs and labels into 1 matrix
omat = cat(3, amat, nmat);
olab = [ alab nlab ];

%% save outputs

disp('Saving results...');

% write output to .mat
%save(files.path.output, 'pconn', 'rois', 'omat', 'olab', 'glob', 'node', 'nets', 'files', '-v7.3');
dlmwrite(csv1, omat(:,:,1), ',');
dlmwrite(csv2, omat(:,:,2), ',');

% remove parallel pool
delete(pool);

end

