%tic

%% Add path to the data directory here
%addpath('../model90/gam2.5_nh10.0/alpha0.05');

%%
%list = dir('/Users/charith/Documents/MATLAB/Research/GRS1915/1915_spin_calculation/model86g/alpha0.1/z_fits_cor_rbs.s1915_0829_b.2_0.1');
%list = dir('/Users/charith/Documents/MATLAB/Research/GRS1915/1915_spin_calculation/model83d/alpha0.1/z_fits_*');
%list = dir('z_fits*');

%list = dir('../model90/gam2.5_nh10.0/alpha0.05/z_fits_*');


file_list = {list.name};

clearvars A

nMiDelements=2016;
%nMiDelements=504;
count = 1;
for i=1:length(file_list)
   disp(i)        
   MM = importdata(file_list{i},' '); %This takes the space as the delimiter. Else it takes tab.
   szMM = size(MM.data);
   if szMM(1)==nMiDelements %This puts out some observations %257 alpha=0.1
   A(:,:,count) = MM.data;
   count = count + 1;
   end
end

%toc