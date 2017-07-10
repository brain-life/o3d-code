function Gen_data_for_plot()

% Define path to the NEW LiFE
Encode_path = '/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/Revision_Feb2017/encode/';
addpath(genpath(Encode_path));

dataOutputPath = '/N/dc2/projects/lifebid/code/ccaiafa/o3d-code/figures/Figs_SD_Encode/';

%dataRootPath = '/N/dc2/projects/o3d/test3';
dataRootPath = '/N/dc2/projects/o3d/data';


subjects = {'sub-0001','sub-0002','sub-0003','sub-0004',... % STN
            'sub-0005','sub-0006','sub-0007','sub-0008',... % HCP3T
            'sub-0009','sub-0010','sub-0011','sub-0012'};   % HCP7T
%datasets = {'O3D_STN','O3D_STN','O3D_STN','O3D_STN',...
%            'O3D_HCP3T','O3D_HCP3T','O3D_HCP3T','O3D_HCP3T'...
%            'O3D_HCP7T','O3D_HCP7T','O3D_HCP7T','O3D_HCP7T'};
Rep_tags = {'01','02','03','04','05','06','07','08','09','10'};

nSubj = size(subjects,2); % Number of subjects
nRep = 10; % Number of repetitions

nnz_tensor = zeros(nSubj,nRep);
nnz_det = zeros(nSubj,nRep);
nnz_prob = zeros(nSubj,nRep); 
nnz_tensor_afterlife = zeros(nSubj,nRep);
nnz_det_afterlife = zeros(nSubj,nRep);
nnz_prob_afterlife = zeros(nSubj,nRep); 

for iSubj = 1:nSubj
    sub = subjects{iSubj};
    %data = datasets{iSubj};
    
    for r = 1:nRep
        rep = Rep_tags{r};
        disp(['Reading subject ', sub, ', conn ', rep]);
        
        % Tensor
        %FileNameTensor    = deblank(ls(fullfile(dataRootPath, data, 'derivatives', 'life_struct', sub, 'dwi', ...
        %    strcat(sub, '_dwi_var-','dtidet','life_run-',rep,'_life.mat'))));    
        FileNameTensor    = deblank(ls(fullfile(dataRootPath, 'derivatives', 'life_struct', sub, ...
            strcat(sub, '_dwi_var-','dtidet','life_run-',rep,'_life.mat'))));  
        % load fe structure
        load(FileNameTensor); 
        nnz_tenor(iSubj, r) = nnz(fe.life.M.Phi);
        nnz_tensor_afterlife(iSubj, r) = nnz(ttv(fe.life.M.Phi,fe.life.fit.weights,3));        
        % Deterministic
        %FileNameDet    = deblank(ls(fullfile(dataRootPath, data, 'derivatives', 'life_struct', sub, 'dwi', ...
        %    strcat(sub, '_dwi_var-','csddet','life_run-',rep,'_life.mat')))); 
        FileNameDet    = deblank(ls(fullfile(dataRootPath, 'derivatives', 'life_struct', sub, ...
            strcat(sub, '_dwi_var-','csddet','life_run-',rep,'_life.mat')))); 
        % load fe structure
        load(FileNameDet);
        % read nnz
        nnz_det(iSubj, r) = nnz(fe.life.M.Phi);
        nnz_det_afterlife(iSubj, r) = nnz(ttv(fe.life.M.Phi,fe.life.fit.weights,3));
        
        % Probabilistic
%         FileNameProb    = deblank(ls(fullfile(dataRootPath, data, 'derivatives', 'life_struct', sub, 'dwi', ...
%             strcat(sub, '_dwi_var-','csdprob','life_run-',rep,'_life.mat')))); 
        FileNameProb    = deblank(ls(fullfile(dataRootPath, 'derivatives', 'life_struct', sub, ...
            strcat(sub, '_dwi_var-','csdprob','life_run-',rep,'_life.mat')))); 
        % load fe structure
        load(FileNameProb);
        % read nnz
        nnz_prob(iSubj, r) = nnz(fe.life.M.Phi);  
        nnz_prob_afterlife(iSubj, r) = nnz(ttv(fe.life.M.Phi,fe.life.fit.weights,3));
        
    end
   
end

disp('SAVING RESULTS...')
save(fullfile(dataOutputPath,'nnz_results.mat'), 'nnz_prob','nnz_det','nnz_tensor','nnz_prob_afterlife','nnz_det_afterlife','nnz_tensor_afterlife','subjects','datasets','-v7.3')

rmpath(genpath(Encode_path));

end
