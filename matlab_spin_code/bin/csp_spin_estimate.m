function [spin_est spin_est_err] = csp_spin_estimate(MiD_spin, MiD_spin_std, P_mid_norm)
% This function calculates an estimate for spin by summing the product of
% spin value and its probability and dividing by the totally probability

%The code for error has not been done yet. 

MiD_spin_good_ind = find(MiD_spin>0);
MiD_spin_good = MiD_spin(MiD_spin_good_ind);
P_mid_norm_good = P_mid_norm(MiD_spin_good_ind);

spin_est = sum(MiD_spin_good.*P_mid_norm_good)/sum(P_mid_norm_good);

spin_est_err = 0;
end

