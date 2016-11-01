function [rin_est rin_est_err] = csp_rin_estimate(MiD_rin, MiD_rin_std, P_mid_norm)
% This function calculates an estimate for rin by summing the product of
% rin value and its probability and dividing by the totally probability

%The code for error has not been done yet. 

MiD_rin_good_ind = find(MiD_rin>0);
MiD_rin_good = MiD_rin(MiD_rin_good_ind);
P_mid_norm_good = P_mid_norm(MiD_rin_good_ind);

rin_est = sum(MiD_rin_good.*P_mid_norm_good)/sum(P_mid_norm_good);

rin_est_err = 0;
end

