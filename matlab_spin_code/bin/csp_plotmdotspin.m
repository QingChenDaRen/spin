function [hh h] = csp_plotmdotspin( MiD_mdot, MiD_spin, MiD_mdot_std, MiD_spin_std)

%% Good points
MiD_spin_good_ind = find(MiD_spin>-99);
MiD_spin_good = MiD_spin(MiD_spin_good_ind);
MiD_spin_std_good = MiD_spin_std(MiD_spin_good_ind);

MiD_mdot_good = MiD_mdot(MiD_spin_good_ind);
MiD_mdot_std_good = MiD_mdot_std(MiD_spin_good_ind);


axisfontsizesmall=10;
axisfontsize=12;

figure
%Horizontal errorbars
hh = herrorbar(MiD_mdot_good, MiD_spin_good, MiD_mdot_std_good, MiD_mdot_std_good, 'g.');
hh.Marker = 'none';
%Vertical errorbars
h = errorbar(MiD_mdot_good, MiD_spin_good, MiD_spin_std_good, MiD_spin_std_good,'.'); 

hxl=xlabel(['\dot{M} (g/s)'],'fontsize',axisfontsizesmall);
set(hxl,'Interpreter','latex');
ylabel('a^{*}','fontsize',axisfontsize);
axis([0 5 0.0 1.1])
hc = get(h, 'Children');
hc.Color = 'r'; %// data
hc.Marker = 'o';
hc.Markersize = 3; %// data
%set(hc(2),'color','g'); %// error bars
% text(7e-8, 0.85, '(c)');
end