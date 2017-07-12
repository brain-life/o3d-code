function hcp7dtiInit(dwi_src, bval_src, bvec_src, T1w_src, dir_out)
% dtiInit preprocessing for HCP7 ONLY
dwParams = dtiInitParams;
dwParams.rotateBvecsWithRx = 0;
dwParams.rotateBvecsWithCanXform = 1;
dwParams.bvecsFile = bvec_src;
dwParams.bvalsFile = bval_src;
dwParams.eddyCorrect = -1;
dwParams.dwOutMm = [1.05 1.05 1.05];
dwParams.phaseEncodeDir = 3;
dwParams.outDir = dir_out;
dwParams.clobber = 1;
[dt6FileName, outBaseDir] = dtiInit(dwi_src, T1w_src, dwParams)
