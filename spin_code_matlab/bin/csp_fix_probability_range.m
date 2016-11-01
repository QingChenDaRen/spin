function [x, f2_fxdprob] = csp_fix_probability_range(x, f)
%
% This code normalizes the function in such away that the total probability
% is shifted into the region that we are intersted in. In the spin case we
% know that the probability cannot be non-zero below R_in = 1. Hence the 
% implementation of this code, shifts all probability to the space where it
% belongs.
% 
% Nov 18 2015

N_total = trapz(x,f);

ind_below_one = find(x < 1);
f2 = f; 
f2(ind_below_one) = 0;

N_range1_9 = trapz(x,f2);

f2_fxdprob = f2*(N_total / N_range1_9); %Normalized to a probability density of 1

end