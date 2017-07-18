function afqClean4life2trk(fe_src,dt6_src,ref_src,trk_out)
% Load a matlab structure recording the results of LIFE computation
% and compute the dissection of 20 tracts, then store a mat file
%
% afq_src: the name of matlab file with the results of dissection
% ref_src: the reference anatomy/dwi file of tractography
% trk_out: the file name prefix to use for storing the trk tracts

% Definition of the code file name for each tract in AFQ
afq_code{1} = 'ATRl';
afq_code{2} = 'ATRr';
afq_code{3} = 'CSTl';
afq_code{4} = 'CSTr';
afq_code{5} = 'CCgl';
afq_code{6} = 'CCgr';
afq_code{7} = 'CHyl';
afq_code{8} = 'CHyr';
afq_code{9} = 'FMJ';
afq_code{10} = 'FMI';
afq_code{11} = 'IFOFl';
afq_code{12} = 'IFOFr';
afq_code{13} = 'ILFl';
afq_code{14} = 'ILFr';
afq_code{15} = 'SLFl';
afq_code{16} = 'SLFr';
afq_code{17} = 'UFl';
afq_code{18} = 'UFr';
afq_code{19} = 'ARCl';
afq_code{20} = 'ARCr';

% Load the afq structure stored as mat file
load(fe_src);

% Extract the weight fascicles/streamline computed by Life
w = feGet(fe,'fiber weights'); 

% Extract fascicles in (dwi?) acpc space
fg = feGet(fe,'fibers acpc');  
fg = fgExtract(fg, w > 0, 'keep');

% Load dt6 file
dt = dtiLoadDt6(dt6_src);

%fg = AFQ_WholebrainTractography(dt,['test']);
[fg_classified,~,classification,fg]= AFQ_SegmentFiberGroups(dt, fg, [], [], false);
fascicles = fg2Array(fg_classified)

% OLD 
%[fascicles,classification,fg,fg_classified] = feAfqSegment(dt6_src, fg);

% Save results to disk
%save(afq_out,'fascicles','classification','fg_classified');
fgWrite(fg_classified, [trk_out, '_set-ALL.mat']);

% Clean tract parameters
maxDist = 5; %
maxLenStd = 5; %
numNodes = 100;
centralTendency = 'median';
count = 0;
maxIter = 5;

% Write each tract
for t=1:size(fascicles,2)
    trk_subset = [trk_out '_set-' afq_code{t} '_tract.trk'];
    tract = fascicles(t);
    [clean, fibers] = clean_tract(tract, maxDist, maxLenStd, numNodes, centralTendency, count, maxIter);
    write_fg_to_trk(clean, ref_src, trk_subset);
end

