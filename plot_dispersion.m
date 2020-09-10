function plot_dispersion(wn,fr)
    plot(wn',real(fr'),'k.-');
    ax = gca();
    ax.YMinorGrid = 'on';
    ax.XMinorGrid = 'on';
    hold on
%     grid minor
    xline(0);
    xline(1);
    xline(2);
    xline(3);
end