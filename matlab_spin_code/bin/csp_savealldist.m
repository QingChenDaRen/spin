tic

clc 
clear all
close all
% 
% load MiDarray.mat;
% addpath('../model90/gam2.0_nh7.5/alpha0.05');
% list = dir('../model90/gam2.0_nh7.5/alpha0.05/z_fits_*');
% csp_spin_calc_InputFitParams
% csp_spin_calc_SpinCalc
% save('dist_nH7pt5_Gam2pt0_apt05','gaussianSum','rin_range')
% 
% pause(5)
% 
% close all
% clear all
% load MiDarray.mat;
% addpath('../model90/gam3.0_nh7.5/alpha0.05');
% list = dir('../model90/gam3.0_nh7.5/alpha0.05/z_fits_*');
% csp_spin_calc_InputFitParams
% csp_spin_calc_SpinCalc
% save('dist_nH7pt5_Gam3pt0_apt05','gaussianSum','rin_range')
% 
% pause(5)
% 
% close all
% clear all
% load MiDarray.mat;
% addpath('../model90/gam2.5_nh5.0/alpha0.05');
% list = dir('../model90/gam2.5_nh5.0/alpha0.05/z_fits_*');
% csp_spin_calc_InputFitParams
% csp_spin_calc_SpinCalc
% save('dist_nH5pt0_Gam2pt5_apt05','gaussianSum','rin_range')
% 
% 
% pause(5)
% 
% close all
% clear all
% load MiDarray.mat;
% addpath('../model90/gam2.5_nh10.0/alpha0.05');
% list = dir('../model90/gam2.5_nh10.0/alpha0.05/z_fits_*');
% csp_spin_calc_InputFitParams
% csp_spin_calc_SpinCalc
% save('dist_nH10pt0_Gam2pt5_apt05','gaussianSum','rin_range')
% 
% close all
% 
% 
% 
% load MiDarray.mat;
% addpath('../model90/Eflow8_gam2.5_nh7.5/alpha0.05');
% list = dir('../model90/Eflow8_gam2.5_nh7.5/alpha0.05/z_fits_*');
% csp_spin_calc_InputFitParams
% csp_spin_calc_SpinCalc
% 
% pause(5)

% close all
% clear all
% 
% load MiDarray.mat;
% addpath('../model90/Eflow6_gam2.5_nh7.5/alpha0.1');
% list = dir('../model90/Eflow6_gam2.5_nh7.5/alpha0.1/z_fits_*');
% csp_spin_calc_InputFitParams
% csp_spin_calc_SpinCalc
% save('dist_nH7pt5_Gam2pt5_apt1_eflow6','gaussianSum','rin_range')
% 
% pause(5)
% 
close all
clear all

load MiDarray.mat;
addpath('../model93/nh8.0_alpha0.05_part/');
list = dir('../model93/nh8.0_alpha0.05_part/z_fits_*');
csp_spin_calc_InputFitParams
csp_spin_calc_SpinCalc
%save('dist_nH7pt5_Gam2pt5_apt05_eflow8_longrun','gaussianSum','rin_range')

toc

% total 658.64 s, 669.5 s
