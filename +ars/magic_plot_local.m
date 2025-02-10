%%% set pretty plot properties (applies to given figure)
function colors = magic_plot_local(fig)
    arguments
        fig matlab.ui.Figure = gcf
    end
    set(fig,'defaultTextInterpreter','latex')
    set(fig,'defaultLegendInterpreter','latex')
    set(fig,'defaultAxesTickLabelInterpreter','latex')
    set(fig,'defaultAxesFontSize',16)
    set(fig,'defaultLineLineWidth',1.6);
    set(fig,'defaultAxesBox','on');
    colors = lines(7);
end