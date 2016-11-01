function [norm MiD_spin_std_good spin_dist] = csp_gauss_plot3(MiD_spin, MiD_spin_std, P_mid_norm, spin_est)
%This function contains gauss_plot2 and spin_distribution code in one
%function. The spin distribution has been normalized.
%Inputs: spin array and standard deviation array 

%% Plot individual Gaussians
%MiD_spin_good_ind = find(MiD_spin_std>0.000001);  %Ideally this should be zero if all errors are ok
MiD_spin_good_ind = find(MiD_spin_std>1e-10);  
%When the MiD_spin_std values are really low the Gaussians are
%too narrow. This was mainly because the spin value was getting stuck.
%After fixing Gamma it is drastically reduced. But still occurs in some
%cases

MiD_spin_good = MiD_spin(MiD_spin_good_ind);
MiD_spin_std_good = MiD_spin_std(MiD_spin_good_ind);
P_mid_norm_good = P_mid_norm(MiD_spin_good_ind);

n = 1000000;  
% The larger this number, the lesser the error due to using a floor
% function. 

figure (1)
x=0.85:0.0001:1.05;  %when plotting a_star
%x = 1:0.01:10;
for m=1:length(MiD_spin_good)
     norm(m,:)=P_mid_norm_good(m)*normpdf(x,MiD_spin_good(m),...
        MiD_spin_std_good(m)); %Multiplied by probability       
    plot(x,norm(m,:))
    hold on
    
    s{m} = normrnd(MiD_spin_good(m), MiD_spin_std_good(m), 1, floor(P_mid_norm_good(m)*n) );
    %I multiply the number n by the probability so that the
    %distribution reflects the probability. Is there a difference in using
    %floor or ceil?
end
hold off

figure (2)
%Summing all the Gaussians to get distribution. 
%The values of every norm (each Gaussian
%function) at each x resolution element is summed.
gaussianSum = sum(norm,1); %Summed columnwise
%Area under Gaussian sum
n = length(gaussianSum);
gaussianSumArea = sum(gaussianSum(2:n))+(gaussianSum(1)+gaussianSum(n))/2;
%Normalizing the Gaussian
normgaussianSum = gaussianSum/gaussianSumArea;
plot(x,normgaussianSum,'r')


%Summing over the columns, rows?? Or is it just all? Check this. ALL is
%what I want.

spin_dist = [s{:}];
%Histogram of this distribution
[f,x] = hist(spin_dist,100); %Histogram with 100 bins

figure (3)
bar(x,f/trapz(x,f));  %Normlizing by dividing by area
%bar(x,f)
hold on

xlabel('a^{*} = a/M', 'Fontsize', 12);
ylabel('Probability Density', 'Fontsize', 12);

%Plot vertical line at spin estimate
plot([spin_est spin_est], ylim,'g--','Linewidth',2);
hold off

%Textbox
mTextBox = uicontrol('style','text');
set(mTextBox,'String',['alpha = 0.01', 10, 'Power law index = 2.5'], 'Fontsize',12);
set(mTextBox,'Position',[360 320 130 40]);
axis([0 1 0 50])

end
