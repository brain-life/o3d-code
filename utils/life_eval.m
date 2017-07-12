function [] = life_eval_multishell(tck_src, dwi_src, fe_out)
%%
%% LiFE version to manage multishell dwi data
%%

clc

my_vista_soft_path = '/N/dc2/projects/lifebid/Paolo/local/matlab/vistasoft/';
%rmpath(genpath(my_vista_soft_path));
addpath(genpath(my_vista_soft_path));

%vista_soft_path = '/N/dc2/projects/lifebid/code/ccaiafa/vistasoft/';
%addpath(genpath(vista_soft_path));

new_LiFE_path = '/N/dc2/projects/lifebid/Paolo/local/matlab/encode/';
addpath(genpath(new_LiFE_path));

%local_path = '/N/dc2/projects/lifebid/Paolo/code/multishell-mrtrix/';
%addpath(genpath(local_path));


fg = mydtiImportFibersMrtrix(tck_src);
fg_struct.fg = fg;

feFileName    = 'life_build_model'; 

if strfind(tck_src, '_b-1000') > 0
   bvalues_centers = [1000];
elseif strfind(tck_src, '_b-2000') > 0
   bvalues_centers = [2000];
elseif strfind(tck_src, '_b-1k2k') > 0
   bvalues_centers = [1000, 2000];
elseif strfind(tck_src, '_b-1k2k3k') > 0
   bvalues_centers = [1000, 2000, 3000];
else
   bvalues_centers = [2000];
end

% Number of iterations for the optimization
Niter = 500;

L = 360;

%% Build the model
tic
fe = feConnectomeInit(dwi_src, fg_struct.fg, feFileName, [] , dwi_src, [], L,[1,0],0); % We set dwiFileRepeat =  run 02
clear 'fg_struct'
  disp(' ');
disp(['Time for model construction ','(L=',num2str(L),')=',num2str(toc),'secs']);

%% Fit the LiFE_SF model (Optimization)
fe = feSet(fe, 'fit', feFitModel(fe.life.M,feGet(fe, 'dsigdemeaned'), 'bbnnls', Niter, 'preconditioner'));
disp('Fit LiFE model... DONE ');

save(fe_out,'fe','-v7.3');

rmpath(genpath(new_LiFE_path));
rmpath(genpath(vista_soft_path));
rmpath(genpath(local_path));
addpath(genpath(my_vista_soft_path));

end


