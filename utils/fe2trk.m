%% 
%%
%%

function fe2trk(fe_src,ref_src,trk_out)

% Load the fe structure stored as mat file
load(fe_src);

% Extract the weight fascicles/streamline computed by Life
w = feGet(fe,'fiber weights'); 

% Extract fascicles in (dwi?) acpc space
fg = feGet(fe,'fibers acpc');  

% Filter the fascicle with non zero weight
fgLife = fgExtract(fg, w > 0);  

% Store all fascicles/streamline as trk file
write_fg_to_trk(fgLife, ref_src, trk_out);
