function [gaussianSum, rin_range] = csp_gauss_plot_rin(MiD_rin, MiD_rin_std, P_mid_norm, rin_est)
% This function creates three plots 
%(1) All the Gaussians created using the r_in value corresponding to each 
% MiD element and its corresponding covariance error 
%(2) Sum of all these Gaussians to create the full distibution 
%(3) The same distribution created in a different way. This method uses a
%probabilistically determined number of points (P_mid*n) scattered into each of the
%above Gaussians and then making a gaint histogram incorporating all these
%points in order to get the distribution
%
%Note to self: This function contains gauss_plot2 and rin_distribution code in one
%function. The rin distribution has been normalized.

% EDIT : THIS FUNCTION NEEDS TO INCLUDE THE INTEGRAL FROM 1 to 9 SHOWN BY
% JACK IN ORDER TO MOVE THE ALL PROBABILITY TO OCCUR ABOVE RIN 1. integrals
% need to be put in.


%
%
%Inputs: rin array and standard deviation array 
good_ind = find(MiD_rin_std > 0.0005 & P_mid_norm > 0); 
%good_ind = find(MiD_rin_std > 0.00001);  %Ideally this should be zero if all errors are ok
%For alpha = 0.05 nH=7.5 Gam = 2.5, there seems to be some err values which
%are too small.
% Considering only observations where P_mid_norm > 0. This will save time

%MiD_rin_good_ind = find(MiD_rin_std>0); % Getting rid of -99 points
MiD_rin_good = MiD_rin(good_ind);
MiD_rin_std_good = MiD_rin_std(good_ind);
P_mid_norm_good = P_mid_norm(good_ind);

num_pts = 1000000;  
% The larger this number, the lesser the error due to using a floor
% function. 

%% Creation of plot (1) and data for plot (3)
figure (1)

Gaussstepsize = 0.0001;

rin_range = 0.5:Gaussstepsize:5;

for m=1:length(MiD_rin_good)
    %This plots all the individual Gaussians in figure (1)    
    norm1=P_mid_norm_good(m)*normpdf(rin_range,MiD_rin_good(m),...
    MiD_rin_std_good(m)); %Multiplied by probability       
    plot(rin_range,norm1)
    hold on
    
    [rin_range, norm(m,:)] = csp_fix_probability_range(rin_range, norm1);
    
    %This line scatters a probabilitically determined number of points
    %(P_mid*n) into each Gaussian and collects the values into the
    %cell-matrix 's'
    s{m} = normrnd(MiD_rin_good(m), MiD_rin_std_good(m), 1, floor(P_mid_norm_good(m)*num_pts) );
    %Note-to-self: Is there an error introduced using
    %floor or ceil? Larger the n, smaller the error.
end
hold off

%% Summing all the Gaussians


figure (2)
%Summing all the Gaussians to get distribution. 
%The values of every norm (each Gaussian
%function) at each rin_range resolution element is summed.
gaussianSum = sum(norm,1); %Summed columnwise
%Area under Gaussian sum
n = length(gaussianSum);
gaussianSumArea = Gaussstepsize*( sum(gaussianSum(2:n-1))+ (gaussianSum(1)+gaussianSum(n))/2 );
%Normalizing the Gaussian
normgaussianSum = gaussianSum/gaussianSumArea;
plot(rin_range,normgaussianSum,'r')
hold on 
%Plot vertical line at spin estimate
plot([rin_est rin_est], ylim,'g--','Linewidth',2);
hold off

xlabel('R_{in} (M)', 'Fontsize', 12);
ylabel('Probability Density (R_{in})', 'Fontsize', 12);

%% Rin distribution using histogram


rin_dist = [s{:}];
%Histogram of this distribution
[f,hist_range] = hist(rin_dist,500); %Histogram with 100 bins

figure (3)
bar(hist_range,f/trapz(hist_range,f));  %Normlizing by dividing by area
%bar(hist_range,f)
hold on


xlabel('R_{in} (M)', 'Fontsize', 12);
ylabel('Probability Density (R_{in})', 'Fontsize', 12);

%Plot vertical line at spin estimate
plot([rin_est rin_est], ylim,'g--','Linewidth',2);
hold off

%Textbox
mTextBox = uicontrol('style','text');
set(mTextBox,'String',['alpha = 0.01', 10, 'Power law index = 2.5'], 'Fontsize',12);
set(mTextBox,'Position',[360 320 130 40]);

xlim([1 9])

%Adding Spin axis on top

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
xlabel(ax2, 'a^{*} = a/M', 'Fontsize', 12);

%Input spin values
spinaxisvals = [1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0.0];
[rin_vals] = csp_rin_calc_noerr(spinaxisvals, 1);

ax2_length = 1; %Default value
xtickvals = (ax2_length/(ax1.XLim(2)-ax1.XLim(1))).*(rin_vals-ax1.XLim(1));
set(ax2,'XTick',xtickvals);
set(ax2,'XTickLabel',spinaxisvals);


% num = [1.0000, 2.3209, 2.9066, 3.3931, 3.8291, 4.2330, 4.6143, 4.9786, 5.3294, 5.6693, 6.0000, ...
%     6.3229, 6.6390, 6.9493, 7.2543, 7.5546, 7.8507, 8.1430, 8.4318, 8.7174, 9.0000];
% 
% ax2_length = 1; %Default value
% xtickvals = (ax2_length/(max(num)-min(num))).*(num-1);
% set(ax2,'XTick',xtickvals);
% set(ax2,'XTickLabel',[1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0.0, -0.1, -0.2, -0.3, ...
%     -0.4, -0.5, -0.6, -0.7, -0.8, -0.9, -1]);


end
