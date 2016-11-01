function [P_mid P_mid_norm] = csp_Pmid_calc( A , M1, ang, D, n)
%A is the matrix with all fit parameters
% M1 is the mass distribution function
% ang is the inclination distribution function
% D is the distance distribution function 
% n is the total number of values in all distribution functions


%% Step size for PDF resolution elements
%mass 8 - 19
massstep = 1.0;
%inc 42 - 69.5
incstep = 2.5;
%dist 6.0 - 12.5
diststep = 0.5;

for i=1:2016
    %% MiD
    mass(i) = A(i,3,1);
    inc(i) = A(i,4,1);
    dist(i) = A(i,5,1);

%% Naive Probability; without using the Reid cumulative distributions
    %P_mid(i) = exp(-(((mass(i)-mass0)^2)/(2*sigM^2))...
    %    -(((inc(i)-inc0)^2)/(2*siginc^2))-(((dist(i)-dist0)^2)/(2*sigdist^2)));
    
%% Probability assignment using Reid's distribution functions for M, i and D
%No resolution error because step size is used as resolution width
    
    mass_res_pdf = [mass(i)-(massstep/2) mass(i)+(massstep/2)];
    inc_res_pdf = [inc(i)-(incstep/2) inc(i)+(incstep/2)];
    dist_res_pdf = [dist(i)-(diststep/2) dist(i)+(diststep/2)];

    %How many values out of 5000 fall within step range
    N_mass = length(find(M1>mass_res_pdf(1) & M1<mass_res_pdf(2)));
    N_inc = length(find(ang>inc_res_pdf(1) & ang<inc_res_pdf(2)));
    N_dist = length(find(D>dist_res_pdf(1) & D<dist_res_pdf(2)));
    
    
    P_m(i) = N_mass/n;
    P_i(i) = N_inc/n;
    P_d(i) = N_dist/n;
    
    P_mid(i) = P_m(i) + P_i(i) + P_d(i); %incorrect
    
end
%Normalizing each distribution to 1

P_m = P_m/max(P_m);
P_i = P_i/max(P_i);
P_d = P_d/max(P_d);


%Normalizing P_mid

%P_mid_norm = P_mid/max(P_mid);

%This should be fine, until I interpolate using 3D
P_mid_norm = (P_m.*P_i.*P_d)/sum(P_m.*P_i.*P_d);
end