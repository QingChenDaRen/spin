function [P_mid P_mid_norm] = csp_Pmid_calc2( A , M1, ang, D, n, nMiDelements)
%VERSION 2.0 
%A is the matrix with all fit parameters
% M1 is the mass distribution function
% ang is the inclination distribution function
% D is the distance distribution function 
% n is the total number of values in all distribution functions


%M1 ang and D are dependent on each other. This dependency is saved in
%the array order. So we can assume a cube of M1, ang and D

%% Step size for PDF resolution elements
%mass 8 - 19
massstep = 1.0;
%inc 42 - 69.5
incstep = 2.5;
%dist 6.0 - 12.5
diststep = 0.5;

mass_ind = zeros(1,n);
inc_ind = zeros(1,n);
dist_ind = zeros(1,n);


for i=1:nMiDelements
    %% MiD
    mass(i) = A(i,3,1);
    inc(i) = A(i,4,1);
    dist(i) = A(i,5,1);
    

%% Naive Probability; without using the Reid cumulative distributions
    %P_mid(i) = exp(-(((mass(i)-mass0)^2)/(2*sigM^2))...
    %    -(((inc(i)-inc0)^2)/(2*siginc^2))-(((dist(i)-dist0)^2)/(2*sigdist^2)));
    
%% Probability assignment using Reid's distribution functions for M, i and
%% D. We assume cubes with side lengths equal to resolution elements
%% and calculate the probability for each cube
%No resolution error because step size is used as resolution width
    mass_res_pdf = [mass(i)-(massstep/2) mass(i)+(massstep/2)];
    inc_res_pdf = [inc(i)-(incstep/2) inc(i)+(incstep/2)];
    dist_res_pdf = [dist(i)-(diststep/2) dist(i)+(diststep/2)];

% The indices corresponding to each points within the resolution element
    mass_ind = find(M1>mass_res_pdf(1) & M1<mass_res_pdf(2));
    inc_ind  = find(ang>inc_res_pdf(1) & ang<inc_res_pdf(2));
    dist_ind = find(D>dist_res_pdf(1) & D<dist_res_pdf(2));
   
% How many values out of n fall within a CUBE   
    NumOfPoints(i) = length(intersect(intersect(mass_ind,inc_ind),dist_ind));
        
%Probability 
    P_mid(i) = NumOfPoints(i)/n;
   
end

%Normalizing P_mid over all points

 P_mid_norm = P_mid/sum(P_mid);

end