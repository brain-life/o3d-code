function hcp7acpc(t1w_src, t1w_out)
%% AC-PC align

eval('!module load spm/8')

ni_anat = niftiRead( t1w_src );
ni_anat = niftiApplyCannonicalXform( ni_anat );

% Load a standard template from vistasoft
MNI_template =  fullfile(mrDiffusionDir, 'templates', 'MNI_T1.nii.gz');

% Compute the spatial normalization to align the current raw data to the template
SpatialNormalization = mrAnatComputeSpmSpatialNorm(ni_anat.data, ni_anat.qto_xyz, MNI_template);

% Assume that the AC-PC coordinates in the template are in a specific location:
% X, Y, Z = [0,0,0; 0,-16,0; 0,-8,40]
% Use this assumption and the spatial normalization to extract the corresponding AC-PC location on the raw data
coords = [0,0,0; 0,-16,0; 0,-8,40];
ImageCoords = mrAnatGetImageCoordsFromSn(SpatialNormalization, tal2mni(coords)', true)';

% Now we assume that ImageCoords contains the AC-PC coordinates that we need for the Raw data. 
% We will use them to compute the AC_PC alignement automatically. The new file will be saved to disk. 
% Check the alignement.
mrAnatAverageAcpcNifti(ni_anat, t1w_out, ImageCoords, [], [], [], false);
