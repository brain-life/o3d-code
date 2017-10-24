
To build connectivity matrices were used tractograms evaluated by the LiFE 
method. Connectivity matrices were built for each fascicle groups using the 
68 brain regions segmented in each individual using T1w MRI images and 
FreeSurfer. Fascicles terminations were mapped onto each of the 68 regions. 
All fibers connecting pairs of brain regions were identified and collected. 
Adjacency matrices were build using two measures: (A) Count, by computing 
the number of fascicles connecting each unique pair of regions, (B) Density, 
by computing the density of fibers connecting each unique pair - computed as 
twice the number of fascicles between regions divided by sum of the number 
of voxels in the two atlas regions. Open source software implementing the 
method can be found at: https://github.com/brain-life/app-networkneuro 

References

If using connectomes based on fiber counts:
- Cheng, H. et al. Characteristics and variability of structural networks 
  derived from diffusion tensor imaging. Neuroimage 61, 1153-1164 (2012).

If using connectomes based on fiber density:
- Buchanan, C. R., Pernet, C. R., Gorgolewski, K. J., Storkey, A. J. and 
  Bastin, M. E. Test-retest reliability of structural brain networks from 
  diffusion MRI. Neuroimage 86, 231-243 (2014).
