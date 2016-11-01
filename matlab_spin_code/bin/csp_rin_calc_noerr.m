function [r] = csp_rin_calc_noerr(a_star, sign)
% This function calculates Rin from the spin 
%Building a grid of a_star values
a_star_grid = -1:0.0001:1;

%Calculating corresponding r grid
Z1 = 1 + ((1 - a_star_grid.^2).^(1/3)).*((1 + a_star_grid).^(1/3) + (1 - a_star_grid).^(1/3));
Z2 = (3*a_star_grid.^2 + Z1.^2).^(1/2);
% If sign = 1 it is prograde. sign = -1 is retrograde
r_grid = 3 + Z2 - sign*((3 - Z1).*(3 + Z1 + 2*Z2)).^(1/2);

%Using cubic spline to calculate all values
r = spline(a_star_grid,r_grid,a_star);

end