!module load spm/8

restoredefaultpath
rootpath = '/N/dc2/projects/lifebid/';
addpath(genpath(fullfile(rootpath,'code/ccaiafa/Caiafa_Pestilli_paper2015/lifebid/')))
addpath(genpath(fullfile(rootpath,'code/vistasoft')))
addpath(genpath(fullfile(rootpath,'code/franpest/AFQ/')))

subject = {'352738'};
runType = {'connNUM01','connNUM02','connNUM03','connNUM04', ...
           'connNUM05','connNUM06','connNUM07','connNUM08', ... 
           'connNUM09','connNUM10'};
trackingType = {'tensor_', ...
                'SD_PROB_lmax2', 'SD_STREAM_lmax2', ...
                'SD_PROB_lmax4', 'SD_STREAM_lmax4', ...
                'SD_PROB_lmax6', 'SD_STREAM_lmax6', ...
                'SD_PROB_lmax8', 'SD_STREAM_lmax8', ...
                'SD_PROB_lmax10','SD_STREAM_lmax10', ...
                'SD_PROB_lmax12','SD_STREAM_lmax12', ...
                };
fe_path      = './fepath';
tracts_path  = './major_tracts/';

for iTrack = 1:length(trackingType)
for isbj = 1:length(subject)
    for iRun = 1:length(runType)
        fprintf('\n Working on Subject %s Run#%i \n',subject{isbj},iRun)
        % Prepare file names to load from and write to disk
        fe_name = sprintf('fe_structure_%s_STC_run01_%s_%s.mat', subject{isbj},trackingType{iTrack},runType{iRun});
        fasciclesClassificationSaveName = sprintf('fe_structure_%s_STC_run01_500000_%s_%s_TRACTS.mat', ...
                 subject{isbj},trackingType{iTrack}, runType{iRun});
        dtFile  = sprintf('./%s/dt6_b2000trilin/dt6.mat',subject{isbj});
        
        fe_file = fullfile(fe_path,subject{isbj},fe_name);
        tracts_file = fullfile(fe_path,fasciclesClassificationSaveName);
        
        if ~exist(tracts_file,'file')
        disp('Load FE structure...')
        load(fe_file);
        w = feGet(fe,'fiber weights');
        
        disp('Extract fibers...')
        fg = feGet(fe,'fibers acpc');        
        clear fe
        fg = fgExtract(fg, w > 0, 'keep');
        
        % Find the major tracts
        disp('Segment tracts...')
        [fg_classified,~,classification]= AFQ_SegmentFiberGroups(dtFile, fg,[],[],false);
        fascicles = fg2Array(fg_classified);
        clear fg
        disp('Save results to disk...')
        save(tracts_file,'fg_classified','classification','fascicles','-v7.3')
        fprintf('\n\n\n Saved file: \n%s \n\n\n',fasciclesClassificationSaveName)
        clear fg_classified fascicles
        
        fprintf('\n DONE Subject %s Run#%i \n',subject{isbj},iRun)
        else
        fprintf('\n TRACT %s Subject %s Run#%i FOUDN SKIPPING ...\n',trackingType{iTrack}, subject{isbj},iRun)
        end
    end
end
end
