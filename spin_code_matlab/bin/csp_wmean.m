function [wm wmerr] = csp_wmean(x, xerr)
%This function calculates the weighted mean and its error given values and errors
%Corrects for variance/dispersion

wm = sum(x./(xerr.^2))/sum(1./(xerr.^2));
wmerr = sqrt((1/sum(1./(xerr.^2)))*(1/(length(x)-1))*sum(((x - wm).^2)./(xerr.^2)));
end