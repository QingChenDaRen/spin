close all

% This function plots the Probability Density after loading the saved
% Gaussian Sum Arrays for each parameter


% % Recreate these files before the final run
% load dist_nH7pt5_Gam2pt5_apt01 %loads variable gaussianSum and rin_range
% gaussianSumArr(1,:) = gaussianSum;
% load dist_nH7pt5_Gam2pt5_apt05_2
% gaussianSumArr(2,:) = gaussianSum;
% load dist_nH7pt5_Gam2pt5_apt1 
% gaussianSumArr(3,:) = gaussianSum;

% load dist_nH7pt5_Gam2pt0_apt05 
% gaussianSumArr(1,:) = gaussianSum;
% load dist_nH7pt5_Gam2pt5_apt05_2
% gaussianSumArr(2,:) = gaussianSum;
% load dist_nH7pt5_Gam3pt0_apt05
% gaussianSumArr(3,:) = gaussianSum;

% load dist_nH5pt0_Gam2pt5_apt05 
% gaussianSumArr(1,:) = gaussianSum;
% load dist_nH7pt5_Gam2pt5_apt05_2
% gaussianSumArr(2,:) = gaussianSum;
% load dist_nH10pt0_Gam2pt5_apt05
% gaussianSumArr(3,:) = gaussianSum;

% load dist_nH7pt5_Gam2pt5_apt05_2 
% gaussianSumArr(1,:) = gaussianSum;
% load dist_nH7pt5_Gam2pt5_apt05_eflow8
% gaussianSumArr(2,:) = gaussianSum;
% load dist_nH7pt5_Gam2pt5_apt05_eflow6
% gaussianSumArr(3,:) = gaussianSum;

load dist_nH7pt5_Gam2pt5_apt01_eflow8
gaussianSumArr(1,:) = gaussianSum;
load dist_nH7pt5_Gam2pt5_apt05_eflow8_longrun
gaussianSumArr(2,:) = gaussianSum;
load dist_nH7pt5_Gam2pt5_apt1_eflow8
gaussianSumArr(3,:) = gaussianSum;
 
% load dist_nH7pt5_Gam2pt5_apt01_eflow6
% gaussianSumArr(1,:) = gaussianSum;
% load dist_nH7pt5_Gam2pt5_apt05_eflow6
% gaussianSumArr(2,:) = gaussianSum;
% load dist_nH7pt5_Gam2pt5_apt1_eflow6
% gaussianSumArr(3,:) = gaussianSum;

Gaussstepsize = rin_range(2)-rin_range(1);

S = size(gaussianSumArr);
n = S(2);

for i=1:S(1);
gaussianSumArea(i) = Gaussstepsize*( sum(gaussianSumArr(i, 2:n-1))+ (gaussianSumArr(i,1)+gaussianSumArr(i,n))/2 );
%Normalizing the Gaussian
normgaussianSum(i,:) = gaussianSumArr(i,:)/gaussianSumArea(i);

end


%Summing over the alpha values

normgaussianSum_alphaSum = sum(normgaussianSum,1); %column-wise sum

figure

plot(rin_range,normgaussianSum(1,:),'r.');
hold on
plot(rin_range,normgaussianSum(2,:),'b.');
hold on
plot(rin_range,normgaussianSum(3,:),'g.');
hold on
plot(rin_range,normgaussianSum_alphaSum,'k.');
hold on

xlabel('R_{in} (M)', 'Fontsize', 16);
ylabel('Probability Density (R_{in})', 'Fontsize', 16);

axis([1.0 2.5 0 8.5])

%% Calculating Rin - assuming Final cumulative distribution: 'normgaussianSum_alphaSum'

indCheckMaxRange = find(rin_range>1.4 & rin_range < 2.5); 
%This can be removed once there are no spikes due to bad Gaussians

rin_range2 = rin_range(indCheckMaxRange);

[val, indMaxProb] = max(normgaussianSum_alphaSum(indCheckMaxRange));

MaxProbRin = rin_range2(indMaxProb)

plot([MaxProbRin MaxProbRin], ylim,'k--','Linewidth',2);
hold on

%% Calculating Rin error (Inefficient)

indRinNegErrorRange = find(rin_range > 1 & rin_range < MaxProbRin);
indRinPosErrorRange = find(rin_range > MaxProbRin & rin_range < 5);

RinNegErrorRange = rin_range(indRinNegErrorRange);
NegErrF = normgaussianSum_alphaSum(indRinNegErrorRange);

RinPosErrorRange = rin_range(indRinPosErrorRange);
PosErrF = normgaussianSum_alphaSum(indRinPosErrorRange);

NegAreatotal = trapz(RinNegErrorRange,NegErrF); % Integral of lower half of distribution
PosAreatotal = trapz(RinPosErrorRange,PosErrF); % Integral of upper half of distribution

    % Arrays shortened to speed up the loop and to make trapz work
for i=100:length(RinNegErrorRange)-10  
    
   NegConf(i) = trapz(RinNegErrorRange(i:end),NegErrF(i:end))/NegAreatotal; 
   NegRin(i) = RinNegErrorRange(i); % Lower Rin limit
end

for i=20000:length(RinPosErrorRange)-10
    
   PosConf(i) = trapz(RinPosErrorRange(1:(end+1)-i),PosErrF(1:(end+1)-i))/PosAreatotal; 
   PosRin(i) = RinPosErrorRange((end+1)-i); % Upper Rin limit
end


%90 % confidence limits
CONF = 0.90; %Change this value if any other confidence values are required

[~, neg_ind] = min(abs(NegConf - CONF));
[~, pos_ind] = min(abs(PosConf - CONF));

rin_nerr = NegRin(neg_ind)
rin_perr = PosRin(pos_ind)

plot([rin_nerr rin_nerr], ylim,'k--','Linewidth',1);
hold on
plot([rin_perr rin_perr], ylim,'k--','Linewidth',1);
hold on

%% Spin value from probability distribution
a_star_range = 0.8:0.00001:1; %Make sure this range is large enough!
[r_check] = csp_rin_calc_noerr(a_star_range, 1);

%Spin value from probability distribution
[~, a_star_ind] = min(abs(r_check - MaxProbRin));
%a_star_negerr = positive Rin err and vice versa
[~, a_star_negerr_ind] = min(abs(r_check - rin_perr));
[~, a_star_poserr_ind] = min(abs(r_check - rin_nerr));

a = a_star_range(a_star_ind)

a_nerr = a_star_range(a_star_negerr_ind)
a_perr = a_star_range(a_star_poserr_ind)


%SOMETHING WRONG WITH THE SCALES or VALUES. Check a_nerr

%% Adding Spin axis on top

ax1 = gca; % current axes
set(ax1,'Box','off');
%ax1_xticks = ax1.XTick;
%ax1_xlabels = ax1.XTickLabel;
ax1_pos = ax1.Position; % position of first set of axes
%set(ax1,'Xscale','log')

ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'YTick', [], 'YTickLabel', [], ...
    'Color','none');
%set(ax2, 'Xdir', 'reverse')
xlabel(ax2, 'a^* = a/M', 'Fontsize', 16);

%Input spin values
spinaxisvals = [0.998, 0.99, a, 0.95, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1];
[rin_vals] = csp_rin_calc_noerr(spinaxisvals, 1);

ax2_length = 1; %Default value
xtickvals = (ax2_length/(ax1.XLim(2)-ax1.XLim(1))).*(rin_vals-ax1.XLim(1));
set(ax2,'XTick',xtickvals);
set(ax2,'XTickLabel',spinaxisvals);








