model = mphload("C:\Users\alex\OneDrive - California Institute of Technology\Documents\Graduate\Research\COMSOL interfacing\2D_dispersion_beta.mph");
mphlaunch(model);
output = mphmatrix(model,'sol1','out',{'K','E','Kc','Ec'});
% full(output.K)
% full(output.E)


