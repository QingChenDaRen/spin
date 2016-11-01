function [r, r_err] = csp_rin_calc(a_star, a_star_err, sign)
% This function calculates Rin and its error from the spin 

%NOTE: a_star_perr could be larger than 1. If so it will cause complex numbers for
%r_perr. Therefore if a_star_perr < 1 we throw  a_star_perr away 

%Calculating positive and negative error for a*
a_star_perr = a_star_err + a_star;
a_star_nerr = a_star - a_star_err;

%Building a grid of a_star values
a_star_grid = -1:0.0001:1;

%Calculating corresponding r grid
Z1 = 1 + ((1 - a_star_grid.^2).^(1/3)).*((1 + a_star_grid).^(1/3) + (1 - a_star_grid).^(1/3));
Z2 = (3*a_star_grid.^2 + Z1.^2).^(1/2);
% If sign = 1 it is prograde. sign = -1 is retrograde
r_grid = 3 + Z2 - sign*((3 - Z1).*(3 + Z1 + 2*Z2)).^(1/2);

%Using cubic spline to calculate all values
r = spline(a_star_grid,r_grid,a_star);

% a_star_nerr gives r_perr and a_star_perr gives r_nerr since 
% scales are inverse.
r_perr = spline(a_star_grid,r_grid,a_star_nerr);

if ( a_star_perr < 1 )

r_nerr = spline(a_star_grid,r_grid,a_star_perr);
r_err = r.*(((r_perr./r) - 1).* ((r./r_nerr) -1)).^(0.5);

else
 
r_err = r_perr-r;
 
end

end