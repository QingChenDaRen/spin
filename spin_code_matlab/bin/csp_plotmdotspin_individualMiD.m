%% Plots Mdot vs Spin
close all
clearvars mdot_val2 mdot_covar_err2 spin_val2 spin_covar_err2 ...
    ledd3 GoodvalswithinMiD_ind rchi
clearvars mdot_val3 mdot_covar_err3 spin_val3 spin_covar_err3 ...
    ledd3 GoodvalswithinMiD_ind2 rchi

eta = 0.42;  % CHECK this value. This is assuming max spin
c = 2.998e8;
mass0 = 12.4; %OR do I take the mass of the MiD element that I use??

%MiDelement_ind = find(MiD_mass<12.5 & MiD_mass>11.5 & MiD_inc<61 & MiD_inc>59 & MiD_dist>8 &  MiD_dist<9);
MiDelement_ind = 508;
%MiDelement_ind = find(MiD_mass<13.5 & MiD_mass>10.5 & MiD_inc<62 & MiD_inc>58 & MiD_dist>7.5 &  MiD_dist<9.5);

GoodvalswithinMiD_ind = GoodInd{MiDelement_ind};

mass_of_ind = MiD_mass(MiDelement_ind);

%% Goodind observations
%Using 2 after the variable names here because the name is used in the main
%program
mdot_val2(1:length(GoodvalswithinMiD_ind)) = A(MiDelement_ind,6,GoodInd{MiDelement_ind});
mdot_covar_err2(1:length(GoodvalswithinMiD_ind)) = A(MiDelement_ind,7,GoodInd{MiDelement_ind});
spin_val2(1:length(GoodvalswithinMiD_ind)) = A(MiDelement_ind,8,GoodInd{MiDelement_ind});
spin_covar_err2(1:length(GoodvalswithinMiD_ind)) = A(MiDelement_ind,9,GoodInd{MiDelement_ind});
ledd2 = (eta*(1e18)*mdot_val2*c^2)/((1.3*10^38)*(1e-4)*mass_of_ind); 

%% All observations

%[Nelm Nparam Nspec] = size(A);



%Try only using observations with rchi <5;
rchi = (A(MiDelement_ind,1,:)./A(MiDelement_ind,2,:)) ;
fsc = A(MiDelement_ind,26,:) ;

GoodvalswithinMiD_ind2 = find(rchi<5  & fsc<0.25);

mdot_val3(1:length(GoodvalswithinMiD_ind2)) = A(MiDelement_ind,6,GoodvalswithinMiD_ind2);
mdot_covar_err3(1:length(GoodvalswithinMiD_ind2)) = A(MiDelement_ind,7,GoodvalswithinMiD_ind2);
spin_val3(1:length(GoodvalswithinMiD_ind2)) = A(MiDelement_ind,8,GoodvalswithinMiD_ind2);
spin_covar_err3(1:length(GoodvalswithinMiD_ind2)) = A(MiDelement_ind,9,GoodvalswithinMiD_ind2);
ledd3 = (eta*(1e18)*mdot_val3*c^2)/((1.3*10^38)*(1e-4)*mass_of_ind); 

figure(1)

plot(ledd2, spin_val2, 'ro')
hold on 
plot(ledd3, spin_val3, 'b*')
axis([0 5.5 0 1])
hold off

% figure (2)

%plot(A(MiDelement_ind,26,:), 'b*')

