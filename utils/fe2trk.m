function fe2trk(fe_src,ref_src,trk_out)
% Load an fe structure and store as trk file all the fibers
% with non zero weights according to the reference nifti image

% Load the fe structure stored as mat file
load(fe_src);

% Extract the weight fascicles/streamline computed by Life
w = feGet(fe,'fiber weights'); 

% Extract fascicles in (dwi?) acpc space
fg = feGet(fe,'fibers acpc');  

% Filter the fascicle with non zero weight
ind = find(w>0);
fgLife = fgExtract(fg, ind);  

% Store all fascicles/streamline as trk file
write_fg_to_trk(fgLife, ref_src, trk_out);
