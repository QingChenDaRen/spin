% VERSION 3.0 - Main Spin Calc function
%tic
close all

% Constants
    eta = 0.42;  % CHECK this value. This is assuming max spin
    c = 2.998e8;
    
    %% Input parameters values and errors for grs1915
    global mass0 inc0 dist0 sigM siginc sigdist
    mass0 = 12.4;
    sigM = 2.0;
    inc0= 60;
    siginc = 5;
    dist0 = 8.6;
    sigdist = 2.0;

%% Variables
    covar_high_bound = 0.2; 
    cover_low_bound = 0.001;
    covar_introval = 0.05;
    
%% Preallocating variables
% nMiDelements = 2016;
nMiDelements = 504;

    MiD_mdot     = zeros(1,nMiDelements);
    MiD_mdot_std = zeros(1,nMiDelements);
    MiD_spin     = zeros(1,nMiDelements);
    MiD_spin_std = zeros(1,nMiDelements);
    GoodInd = {};
    
%% For each MiD
for i=1:nMiDelements    
    % A comes from spin_calc_test.m
    % Three parameters required for constraints taken from A; rchi, fsc, L_disk(mdot)
    
    rchi = (A(i,1,:)./A(i,2,:));                                % Reduced Chi Square
    fsc = A(i,18,:);                                            % Scattering Fraction
    mdot = A(i,6,:);                                            % Mass Accretion Rate
    ledd = (eta*(1e18)*mdot*c^2)/((1.3*10^38)*(1e-4)*mass0);    % Calculated Eddington luminosity
    
    % The indices of the array associated to MiD element that satisfy constraints
    GoodInd{i} = find(rchi<5 & fsc<0.25 & ledd<0.3 & ledd>0.03);
    
    % Assigning to variable names
    MiD_mass(i) = A(i,3,1);
    MiD_inc(i) = A(i,4,1);
    MiD_dist(i) = A(i,5,1);
    
    
    mdot_val = A(i,6,GoodInd{i});
    mdot_covar_err = A(i,7,GoodInd{i});
    spin_val = A(i,8,GoodInd{i});
    spin_covar_err = A(i,9,GoodInd{i});
    
   
    % Checking for failure in covariance errors
    mdot_covar_err_fail_ind = find(mdot_covar_err >= covar_high_bound | mdot_covar_err <= cover_low_bound);
    mdot_covar_err(mdot_covar_err_fail_ind) = covar_introval; %Introduced a reasonable value for error (value defined above)
    spin_covar_err_fail_ind = find(spin_covar_err >= covar_high_bound | spin_covar_err <= cover_low_bound);
    spin_covar_err(spin_covar_err_fail_ind) = covar_introval; %Introduced a reasonable value for error (value defined above)
    
    
 %% HOW TO GET SAME VALUE OUT   
    %Getting rid of values which are exactly equal so as not to cause
    %spikey Gaussians (for alpha = 0.5)
%     if (sum(spin_val - mean(spin_val)) == 0)
%        
%         spin_val = mean(spin_val);
%         spin_covar_err = mean(spin_covar_err);
%         
%     end
    
    % Transforming Spin and Spin uncertainty to R_in and R_in uncerntainty
    [rin_val, rin_covar_err] = csp_rin_calc(spin_val, spin_covar_err, 1); %1 is for prograde, -1 for retrograde
    
    
%% mean spin and mdot; error calculated using covariance error
    nGood(i) = length(GoodInd{i});
    if (nGood(i)>1)
            
        [MiD_mdot(i) MiD_mdot_std(i)] = csp_wmean(mdot_val, mdot_covar_err);
        [MiD_spin(i) MiD_spin_std(i)] = csp_wmean(spin_val, spin_covar_err);
        [MiD_rin(i) MiD_rin_std(i)] = csp_wmean(rin_val,  rin_covar_err);
        
    elseif (nGood(i)>0) %basically if nGood ==1
        
        %Since there is no dispersion when there is only one good point:
        MiD_mdot(i) = mdot_val;
        MiD_mdot_std(i) = mdot_covar_err;
        MiD_spin(i) = spin_val;
        MiD_spin_std(i) = spin_covar_err;  
        MiD_rin(i) = rin_val;
        MiD_rin_std(i) = rin_covar_err;
        
    else
        
        MiD_mdot(i)      = -99; MiD_mdot_std(i)  = -99; 
        MiD_spin(i)      = -99; MiD_spin_std(i)  = -99;
        MiD_rin(i)       = -99; MiD_rin_std(i)  = -99;
        
    end
       
end


%% Calculation of probability; (M1, ang, D, n comes from Reid_parameter_calc.m )
[P_mid P_mid_norm] = csp_Pmid_calc2( A , M1, ang, D, n, nMiDelements);

%% Plot mdot Vs spin (not necessary)
%csp_plotmdotspin( MiD_mdot, MiD_spin, MiD_mdot_std, MiD_spin_std)

%% R_in estimate
[rin_est rin_est_err] = csp_rin_estimate(MiD_rin, MiD_rin_std, P_mid_norm);

%% Plot Gaussians
[gaussianSum, rin_range] = csp_gauss_plot_rin(MiD_rin, MiD_rin_std, P_mid_norm, rin_est);

%[norm MiD_spin_std_good spin_dist] = csp_gauss_plot_spin(MiD_spin, MiD_spin_std, P_mid_norm, spin_est);

%toc

