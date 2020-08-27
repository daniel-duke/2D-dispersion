function plot_dispersion(wn,fr)
    figure();
    plot(wn',fr','k.-');
    hold on
    xline(0);
    xline(1);
    xline(2);
    xline(3);
end