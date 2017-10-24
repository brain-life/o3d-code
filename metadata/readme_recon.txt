
The dMRI signal within each voxel was reconstructed using the two dominant 
models, namely the diffusion tensor (DTI) and constrained-spherical 
deconvolution (CSD). Specifically, when applying CSD, we utilized an Lmax 
parameter of 8. White- and gray-matter tissues were segmented using the 
T1-weighted MRI images associated to each individual brain, and then 
resampled at the resolution of the dMRI data.

References

If using Diffusion Tensor (DTI):
- Veraart, J.; Sijbers, J.; Sunaert, S.; Leemans, A. & Jeurissen, B.
  Weighted linear least squares estimation of diffusion MRI parameters:
  strengths, limitations, and pitfalls. NeuroImage, 2013, 81, 335-346

If using Constrained Spherical Deconvolution (CSD):
- Tournier, J.-D.; Calamante, F. & Connelly, A. Robust determination of the 
  fibre orientation distribution in diffusion MRI: Non-negativity constrained 
  super-resolved spherical deconvolution. NeuroImage, 2007, 35, 1459-1472

