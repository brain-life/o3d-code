function afq2trk(afq_src,ref_src,trk_out)
% Load a matlab structure recording the results of AFQ computation
% and store a trk file for each of 20 dissected tracts
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
afq=load(afq_src);
fg=afq.fg;

% Write each tract
for t=1:size(fg,2)
    trk_subset = [trk_out '_set-' afq_code{t} '_tract.trk'];
    write_fg_to_trk(fg(t), ref_src, trk_subset);
end
